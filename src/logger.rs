use crate::model::AppRunConfiguration;
use std::ops::Add;
use std::path::MAIN_SEPARATOR;
use tokio::fs;
use tokio::fs::File;
use tokio::io::{AsyncWriteExt, Result};

pub(crate) async fn log_server_start(config: AppRunConfiguration) -> Result<()> {
    let filename: String = vec![config.run_time.to_rfc3339(), String::from(".log")].join("");
    let destination = vec![".", "var", "log"].join(&MAIN_SEPARATOR.to_string());
    let filepath = vec![
        destination.clone(),
        sanitize_filename::sanitize_with_options(
            filename,
            sanitize_filename::Options {
                truncate: true,
                windows: true,
                replacement: "",
            },
        ),
    ]
    .join(&MAIN_SEPARATOR.to_string());

    fs::create_dir_all(destination.clone()).await?;

    let mut file = File::create(filepath.clone()).await?;

    let data = String::new()
        .add("Student: Damian Szopiński\n")
        .add("Port: ")
        .add(&*config.listen_port.to_string())
        .add("\n")
        .add("IP: ")
        .add(&*config.listen_ip)
        .add("\n")
        .add("Started at: ")
        .add(&config.run_time.to_rfc3339())
        .add("\n");

    file.write_all(&*data.into_bytes()).await?;

    Ok(())
}
