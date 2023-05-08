mod hello_service;
mod logger;
mod model;

use actix_web::{App, HttpServer};
use chrono::Local;
use tokio::io::Result;

use model::*;

#[tokio::main]
async fn main() -> Result<()> {
    let app_conf = AppRunConfiguration {
        run_time: Local::now(),
        listen_ip: String::from("127.0.0.1"),
        listen_port: 8080,
    };

    logger::log_server_start(app_conf.clone()).await?;

    HttpServer::new(|| App::new().service(hello_service::hello))
        .bind((app_conf.listen_ip, app_conf.listen_port))?
        .run()
        .await
}
