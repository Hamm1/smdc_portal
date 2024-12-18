
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