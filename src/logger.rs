use crate::model::AppRunConfiguration;
use std::ops::Add;
use tokio::fs;
use tokio::fs::File;
use tokio::io::{AsyncWriteExt, Result};

pub(crate) async fn log_server_start(config: AppRunConfiguration) -> Result<()> {
    let filename: String = vec![config.run_time.to_rfc3339(), String::from(".log")].join("");
    let destination = "./var/log";

    fs::create_dir_all(destination).await?;
    let mut file = File::create(vec![destination, &filename].join("/")).await?;

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
