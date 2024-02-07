
use std::fs::File;
use std::io::Read;
use std::io::ErrorKind;
use serde::{Serialize,Deserialize};

#[derive(Debug, Deserialize, Serialize, Clone)]
pub struct Location {
    pub title: String,
    pub url: String,
}

#[derive(Debug, Deserialize, Serialize, Clone)]
pub struct Locations {
    pub locations: Vec<Location>
}

#[tauri::command]
pub fn get_location_variables() -> String {
    let path = get_config_path("locations".into());
    create_missing_directory(path.to_owned(), "locations".into());
    let mut file = match File::open(&path){
        Ok(file) => file,
        Err(error) => match error.kind() {
            ErrorKind::NotFound => match File::create(path) {
                Ok(fc) => fc,
                Err(e) => panic!("Problem creating the file: {:?}", e),
            },
            other_error => {
                panic!("Problem opening the file: {:?}", other_error);
            }
        }
    };
    let mut data = String::new();
    file.read_to_string(&mut data).unwrap_or(0);
    drop(file);
    let mut json: Locations = match serde_json::from_str(&data){
        Ok(json) => json,
        Err(_) => {
                    let con = Locations{ locations: vec![
                                                            Location{title: "Ansible".to_string(), url: "https://smdcansible/".to_string()},
                                                            Location{title: "Solarwinds Helpdesk".to_string(), url: "https://helpdesk.smdc.army.mil/helpdesk/WebObjects/Helpdesk.woa".to_string()},
                                                            Location{title: "PowerBI ACAS Dashboard".to_string(), url: "https://smdhw6huaapb001.smdch.smdc.army.mil/reports/powerbi/SMDC/SMDC_ACAS_Dashboard".to_string()},
                                                            Location{title: "PowerBI User Dashboard".to_string(), url: "https://smdhw6huaapb001.smdch.smdc.army.mil/reports/powerbi/SMDC/USER_Tracking%20(AD)".to_string()},
                                                            Location{title: "PowerBI Computer Dashboard".to_string(), url: "https://smdhw6huaapb001.smdch.smdc.army.mil/reports/powerbi/SMDC/Computer_Tracking%20(AD)".to_string()},
                                                            Location{title: "Helpdesk Tool Grafana".to_string(), url: "https://helpdesktool.smdch.smdc.army.mil/grafana/".to_string()},
                                                            Location{title: "Helpdesk Tool Pocketbase".to_string(), url: "https://helpdesktool.smdch.smdc.army.mil/admin/_/".to_string()},
                                                            Location{title: "Helpdesk Tool Jaeger".to_string(), url: "https://helpdesktool.smdch.smdc.army.mil/jaeger/".to_string()},
                                                            Location{title: "Help Desk Web Tool".to_string(), url: "https://smdchdwi/ticket".to_string()},
                                                        ]
                                        };
                    match std::fs::write(get_config_path("locations".into()), match serde_json::to_string(&con){
                            Ok(r) => r,
                            Err(error) => error.to_string()
                    }){
                        Ok(x) => x,
                        Err(_) => ()
                    };
                    con
                    }
    };

    let path = get_config_path("additional".into());
    create_missing_directory(path.to_owned(), "additional".into());
    let mut file = match File::open(&path){
        Ok(file) => file,
        Err(error) => match error.kind() {
            ErrorKind::NotFound => match File::create(path) {
                Ok(fc) => fc,
                Err(e) => panic!("Problem creating the file: {:?}", e),
            },
            other_error => {
                panic!("Problem opening the file: {:?}", other_error);
            }
        }
    };
    let mut data = String::new();
    file.read_to_string(&mut data).unwrap_or(0);
    drop(file);
    let json2: Locations = match serde_json::from_str(&data){
        Ok(json2) => json2,
        Err(_) => {
                    let con = Locations{ locations: vec![] };
                    match std::fs::write(get_config_path("additional".into()), match serde_json::to_string(&con){
                            Ok(r) => r,
                            Err(error) => error.to_string()
                    }){
                        Ok(x) => x,
                        Err(_) => ()
                    };
                    con
                    }
    };
    for j in json2.locations{
        json.locations.push(j)
    };
    println!("{:?}", json);
    
    return serde_json::to_string(&json).unwrap()
}

#[tauri::command]
pub fn get_additional_variables(qwik: &str) -> String {
    let additional_json: Location = match serde_json::from_str(&qwik){
        Ok(j) => j,
        Err(_) => return "Error".to_string()
    };

    let path = get_config_path("additional".into());
    create_missing_directory(path.to_owned(), "additional".into());
    let mut file = match File::open(&path){
        Ok(file) => file,
        Err(error) => match error.kind() {
            ErrorKind::NotFound => match File::create(path) {
                Ok(fc) => fc,
                Err(e) => panic!("Problem creating the file: {:?}", e),
            },
            other_error => {
                panic!("Problem opening the file: {:?}", other_error);
            }
        }
    };
    let mut data = String::new();
    file.read_to_string(&mut data).unwrap_or(0);
    drop(file);
    let mut json: Locations = match serde_json::from_str(&data){
        Ok(json) => json,
        Err(_) => {
                    let con = Locations{ locations: vec![]};
                    match std::fs::write(get_config_path("additional".into()), match serde_json::to_string(&con){
                            Ok(r) => r,
                            Err(error) => error.to_string()
                    }){
                        Ok(x) => x,
                        Err(_) => ()
                    };
                    con
                    }
    };
    json.locations.push(additional_json);
    println!("{:?}", json);
    
    match std::fs::write(get_config_path("additional".into()), match serde_json::to_string(&json){
        Ok(r) => r,
        Err(error) => error.to_string()
        }){
            Ok(x) => x,
            Err(_) => ()
        };

    return "Success".to_string()
}

pub fn get_config_path(config_name: String) -> String {
  let user = whoami::username();
  let path = match std::env::consts::OS.as_ref() {
        "windows" => format!("{}/{}/{}/{}{}", "C:/Users".to_string(), user, "AppData/Local/SMDC-Portal".to_string(), config_name, ".json".to_string()),
        "linux" => "/home/".to_string() +  &user + &"/Desktop/" + &config_name + &".json".to_string(),
        "macos" => "/Users/".to_string() +  &user + &"/Desktop/" + &config_name + &".json".to_string(),
        _ => panic!("Unsupported OS"),
  };
  return path;
}

pub fn create_missing_directory(path: String, config_name: String) -> String {
    let new_path = config_name + ".json";
    let path = path.replace(&new_path, "");
    if !(std::path::Path::new(&path).exists()){
        match std::fs::create_dir_all(path){
            Ok(_) => return "Created".to_string(),
            Err(_) => return "Error".to_string()
        };
    } else {
        return "Directory Exists".to_string()
    }
}

#[tauri::command]
pub fn get_user() -> String {
    return whoami::username();
}

#[tauri::command]
pub fn get_computer_name() -> String {
    return whoami::hostname();
}
