use serde::{Deserialize, Serialize};
use std::fs::File;
use std::io::ErrorKind;
use std::io::Read;

#[derive(Debug, Deserialize, Serialize, Clone)]
pub struct Location {
    pub id: String,
    pub title: String,
    pub url: String,
    pub removable: bool,
}

#[derive(Debug, Deserialize, Serialize, Clone)]
pub struct Locations {
    pub locations: Vec<Location>,
}

// Required to Map or Filter over Custom Structs
impl std::iter::FromIterator<Location> for Locations {
    fn from_iter<I: IntoIterator<Item = Location>>(iter: I) -> Self {
        let locations: Vec<Location> = iter.into_iter().collect();
        Locations { locations }
    }
}

#[tauri::command]
pub fn get_location_variables() -> String {
    let path = crate::helpers::get_config_path("locations".into());
    crate::helpers::create_missing_directory(path.to_owned(), "locations".into());
    let mut file = match File::open(&path) {
        Ok(file) => file,
        Err(error) => match error.kind() {
            ErrorKind::NotFound => match File::create(path) {
                Ok(fc) => fc,
                Err(e) => panic!("Problem creating the file: {:?}", e),
            },
            other_error => {
                panic!("Problem opening the file: {:?}", other_error);
            }
        },
    };
    let mut data = String::new();
    file.read_to_string(&mut data).unwrap_or(0);
    drop(file);
    let mut json: Locations = match serde_json::from_str(&data) {
        Ok(json) => json,
        Err(_) => {
            let con = Locations{
                locations: vec![
                    Location{id:"1".to_string(),title: "Ansible".to_string(), url: "https://smdcansible/".to_string(),removable:false},
                    Location{id:"2".to_string(),title: "Solarwinds Helpdesk".to_string(), url: "https://helpdesk.smdc.army.mil/helpdesk/WebObjects/Helpdesk.woa".to_string(),removable:false},
                    Location{id:"3".to_string(),title: "PowerBI ACAS Dashboard".to_string(), url: "https://smdhw6huaapb001.smdch.smdc.army.mil/reports/powerbi/SMDC/SMDC_ACAS_Dashboard".to_string(),removable:false},
                    Location{id:"4".to_string(),title: "PowerBI User Dashboard".to_string(), url: "https://smdhw6huaapb001.smdch.smdc.army.mil/reports/powerbi/SMDC/USER_Tracking%20(AD)".to_string(),removable:false},
                    Location{id:"5".to_string(),title: "PowerBI Computer Dashboard".to_string(), url: "https://smdhw6huaapb001.smdch.smdc.army.mil/reports/powerbi/SMDC/Computer_Tracking%20(AD)".to_string(),removable:false},
                    Location{id:"6".to_string(),title: "Helpdesk Tool Grafana".to_string(), url: "https://helpdesktool.smdch.smdc.army.mil/grafana/".to_string(),removable:false},
                    Location{id:"7".to_string(),title: "Helpdesk Tool Pocketbase".to_string(), url: "https://helpdesktool.smdch.smdc.army.mil/admin/_/".to_string(),removable:false},
                    Location{id:"8".to_string(),title: "Helpdesk Tool Jaeger".to_string(), url: "https://helpdesktool.smdch.smdc.army.mil/jaeger/".to_string(),removable:false},
                    Location{id:"9".to_string(),title: "Help Desk Web Tool".to_string(), url: "https://smdchdwi/ticket".to_string(),removable:false},
                ]
            };
            match std::fs::write(
                crate::helpers::get_config_path("locations".into()),
                match serde_json::to_string(&con) {
                    Ok(r) => r,
                    Err(error) => error.to_string(),
                },
            ) {
                Ok(x) => x,
                Err(_) => (),
            };
            con
        }
    };

    let path = crate::helpers::get_config_path("additional".into());
    crate::helpers::create_missing_directory(path.to_owned(), "additional".into());
    let mut file = match File::open(&path) {
        Ok(file) => file,
        Err(error) => match error.kind() {
            ErrorKind::NotFound => match File::create(path) {
                Ok(fc) => fc,
                Err(e) => panic!("Problem creating the file: {:?}", e),
            },
            other_error => {
                panic!("Problem opening the file: {:?}", other_error);
            }
        },
    };
    let mut data = String::new();
    file.read_to_string(&mut data).unwrap_or(0);
    drop(file);
    let json2: Locations = match serde_json::from_str(&data) {
        Ok(json2) => json2,
        Err(_) => {
            let con = Locations { locations: vec![] };
            match std::fs::write(
                crate::helpers::get_config_path("additional".into()),
                match serde_json::to_string(&con) {
                    Ok(r) => r,
                    Err(error) => error.to_string(),
                },
            ) {
                Ok(x) => x,
                Err(_) => (),
            };
            con
        }
    };
    for j in json2.locations {
        json.locations.push(j)
    }
    println!("{:?}", json);

    return serde_json::to_string(&json).unwrap();
}

#[tauri::command]
pub fn get_additional_variables(qwik: &str) -> String {
    let additional_json: Location = match serde_json::from_str(&qwik) {
        Ok(j) => j,
        Err(_) => return "Error".to_string(),
    };

    let path = crate::helpers::get_config_path("additional".into());
    crate::helpers::create_missing_directory(path.to_owned(), "additional".into());
    let mut file = match File::open(&path) {
        Ok(file) => file,
        Err(error) => match error.kind() {
            ErrorKind::NotFound => match File::create(path) {
                Ok(fc) => fc,
                Err(e) => panic!("Problem creating the file: {:?}", e),
            },
            other_error => {
                panic!("Problem opening the file: {:?}", other_error);
            }
        },
    };
    let mut data = String::new();
    file.read_to_string(&mut data).unwrap_or(0);
    drop(file);
    let mut json: Locations = match serde_json::from_str(&data) {
        Ok(json) => json,
        Err(_) => {
            let con = Locations { locations: vec![] };
            match std::fs::write(
                crate::helpers::get_config_path("additional".into()),
                match serde_json::to_string(&con) {
                    Ok(r) => r,
                    Err(error) => error.to_string(),
                },
            ) {
                Ok(x) => x,
                Err(_) => (),
            };
            con
        }
    };
    json.locations.push(additional_json);
    println!("{:?}", json);

    match std::fs::write(
        crate::helpers::get_config_path("additional".into()),
        match serde_json::to_string(&json) {
            Ok(r) => r,
            Err(error) => error.to_string(),
        },
    ) {
        Ok(x) => x,
        Err(_) => (),
    };

    return "Success".to_string();
}

#[tauri::command]
pub fn get_additional_variables_remove(id: &str) -> String {
    let path = crate::helpers::get_config_path("additional".into());
    crate::helpers::create_missing_directory(path.to_owned(), "additional".into());
    let mut file = match File::open(&path) {
        Ok(file) => file,
        Err(error) => match error.kind() {
            ErrorKind::NotFound => match File::create(path) {
                Ok(fc) => fc,
                Err(e) => panic!("Problem creating the file: {:?}", e),
            },
            other_error => {
                panic!("Problem opening the file: {:?}", other_error);
            }
        },
    };
    let mut data = String::new();
    file.read_to_string(&mut data).unwrap_or(0);
    drop(file);
    let json: Locations = match serde_json::from_str(&data) {
        Ok(json) => json,
        Err(_) => {
            let con = Locations { locations: vec![] };
            match std::fs::write(
                crate::helpers::get_config_path("additional".into()),
                match serde_json::to_string(&con) {
                    Ok(r) => r,
                    Err(error) => error.to_string(),
                },
            ) {
                Ok(x) => x,
                Err(_) => (),
            };
            con
        }
    };
    let new_json = json
        .locations
        .into_iter()
        .filter(|x| x.id != id)
        .collect::<Locations>();

    match std::fs::write(
        crate::helpers::get_config_path("additional".into()),
        match serde_json::to_string(&new_json) {
            Ok(r) => r,
            Err(error) => error.to_string(),
        },
    ) {
        Ok(x) => x,
        Err(_) => (),
    };

    return "Success".to_string();
}

#[tauri::command]
pub fn get_user() -> String {
    return whoami::username();
}

#[tauri::command]
pub fn get_computer_name() -> String {
    return whoami::fallible::hostname().unwrap_or("default".to_string());
}
