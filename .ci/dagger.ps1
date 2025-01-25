
function Test-Docker(){
    [CmdletBinding()]
    [OutputType([bool])]
    [version]$os = (Get-CimInstance Win32_OperatingSystem).Version
    [version]$os_required = "10.0.19044"
    if ($os_required -le $os){
        $docker = where.exe "docker.exe"
        if(!(Test-Path "C:\Program Files\Docker\Docker\resources\bin\docker.exe") -and ($null -eq $docker)){
            $test_choco = & curl.exe -o /dev/null --silent -Iw '%{http_code}' 'https://community.chocolatey.org/install.ps1'
            if ($test_choco -eq "200"){
                if (!(Test-Path "C:\\ProgramData\\chocolatey\\bin\\choco.exe")){
                    Write-Host "Chocolatey is not installed..."
                    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
                    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
                }
                
                if (Test-Path "C:\\ProgramData\\chocolatey\\bin\\choco.exe") {
                    Start-Process "C:\\ProgramData\\chocolatey\\bin\\choco.exe" -ArgumentList "install docker-desktop -y" -wait
                }
            } else {
                exit(1)
            }
        }

        $CHECK = get-service *docker* | Where-Object{$_.status -eq "Running"}
        $Docker_images = docker images
        if($null -ne $CHECK -and $null -ne $Docker_images){
            Write-Host "Docker is running..."
            return $true
        } else {
            Start-Service *docker*
            start-process "C:\Program Files\Docker\Docker\Docker Desktop.exe"
            $CHECK = docker images 
            while ($null -eq $CHECK){
                $CHECK = docker images
                Write-Host "Waiting for Docker to Start..."
                start-sleep 5
            }
            return $true
        }
    } else {
        Write-Host "Operating system version is to low to support Docker Desktop..."
        return $false
    }
}

function Test-Dagger(){
    [CmdletBinding()]
    [OutputType([string])]
    $dagger = where.exe "dagger.exe" | Select-Object -First 1
    if(!(Test-Path "C:\ProgramData\chocolatey\bin\dagger.exe") -and ($null -eq $dagger)){
        $test_choco = & curl.exe -o /dev/null --silent -Iw '%{http_code}' 'https://community.chocolatey.org/install.ps1'
        if ($test_choco -eq "200"){
            if (!(Test-Path "C:\\ProgramData\\chocolatey\\bin\\choco.exe")){
                Write-Host "Chocolatey is not installed..."
                [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
                Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
            }
            
            if (Test-Path "C:\\ProgramData\\chocolatey\\bin\\choco.exe") {
                Start-Process "C:\\ProgramData\\chocolatey\\bin\\choco.exe" -ArgumentList "install dagger -y" -wait
            }
            return "C:\ProgramData\chocolatey\bin\dagger.exe"
        } else {
            $test_dagger = & curl.exe -o /dev/null --silent -Iw '%{http_code}' 'https://dl.dagger.io/dagger/install.ps1'
            if ($test_dagger -eq "200"){
                Invoke-WebRequest -UseBasicParsing -Uri https://dl.dagger.io/dagger/install.ps1 | Invoke-Expression;
                Install-Dagger -InstallPath C:\ProgramData\dagger
                return "C:\ProgramData\dagger\dagger.exe"
            } else {
                exit(1)
            }
        }
    } else {
        return $dagger
    }
}

$test_choco = & curl.exe -o /dev/null --silent -Iw '%{http_code}' 'https://community.chocolatey.org/install.ps1'
$test_dagger = & curl.exe -o /dev/null --silent -Iw '%{http_code}' 'https://dl.dagger.io/dagger/install.ps1'
if ($test_choco -ne "200" -and $test_dagger -eq "200") {
    Write-Host -ForegroundColor Red "Unable to contact chocolatey..."
    Write-Host -ForegroundColor Red "Unable to contact daggerverse..."
    exit(1)
}

if ((Test-Docker) -and (Test-Dagger -ne "")){
    Get-Service com.docker.service | Start-Service -ErrorAction SilentlyContinue
    Start-Process "$($Env:ProgramFiles)\Docker\Docker\DockerCli.exe" -ArgumentList "-SwitchLinuxEngine" -Wait -NoNewWindow -ErrorAction SilentlyContinue
    Write-Host "Building..."
    Start-Process "$(Test-Dagger)" -ArgumentList "call linux --src=../ export --path=$((Split-Path (get-location).Path) + '/out/smdc_portal')" -Wait -NoNewWindow
    Start-Process "$(Test-Dagger)" -ArgumentList "call windows --src=../ export --path=$((Split-Path (get-location).Path) + '/out/smdc_portal.exe')" -Wait -NoNewWindow
}
