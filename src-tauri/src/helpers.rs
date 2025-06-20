pub fn get_config_path(config_name: String) -> String {
    let user = whoami::username();
    let path = match std::env::consts::OS.as_ref() {
        "windows" => format!(
            "{}/{}/{}/{}{}",
            "C:/Users".to_string(),
            user,
            "AppData/Local/SMDC-Portal".to_string(),
            config_name,
            ".json".to_string()
        ),
        "linux" => {
            "/home/".to_string() + &user + &"/Desktop/" + &config_name + &".json".to_string()
        }
        "macos" => {
            "/Users/".to_string() + &user + &"/Desktop/" + &config_name + &".json".to_string()
        }
        _ => panic!("Unsupported OS"),
    };
    return path;
}

pub fn create_missing_directory(path: String, config_name: String) -> String {
    let new_path = config_name + ".json";
    let path = path.replace(&new_path, "");
    if !(std::path::Path::new(&path).exists()) {
        match std::fs::create_dir_all(path) {
            Ok(_) => return "Created".to_string(),
            Err(_) => return "Error".to_string(),
        };
    } else {
        return "Directory Exists".to_string();
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    // use std::env;

    #[test]
    fn test_get_config_path() {
        let user = whoami::username();
        let config_name = "test_config".to_string();

        let expected_path = match std::env::consts::OS {
            "windows" => format!(
                "C:/Users/{}/AppData/Local/SMDC-Portal/{}.json",
                user, config_name
            ),
            "linux" => format!("/home/{}/Desktop/{}.json", user, config_name),
            "macos" => format!("/Users/{}/Desktop/{}.json", user, config_name),
            _ => panic!("Unsupported OS for testing"),
        };

        let actual_path = get_config_path(config_name);

        assert_eq!(actual_path, expected_path);
    }

    #[test]
    fn test_get_config_path_different_names() {
        let config_names = vec!["settings", "user_data", "preferences"];

        for name in config_names {
            let path = get_config_path(name.to_string());
            assert!(path.contains(name));
            assert!(path.ends_with(".json"));
        }
    }

    #[test]
    fn test_os_specific_path_format() {
        let config_name = "test_config".to_string();
        let path = get_config_path(config_name);
        let user = whoami::username();

        match std::env::consts::OS {
            "windows" => {
                assert!(path.starts_with("C:/Users/"));
                assert!(path.contains("AppData/Local/SMDC-Portal"));
            }
            "linux" => {
                assert!(path.starts_with("/home/"));
                assert!(path.contains("/Desktop/"));
            }
            "macos" => {
                assert!(path.starts_with("/Users/"));
                assert!(path.contains("/Desktop/"));
            }
            _ => panic!("Unsupported OS for testing"),
        }

        assert!(path.contains(&user));
    }
}
