use chrono::{DateTime, Local};
use std::ops::Add;

#[derive(Debug, Clone)]
pub struct HelloResponse {
    pub ip: String,
    pub current_time: String,
}

#[derive(Debug, Clone)]
pub struct AppRunConfiguration {
    pub run_time: DateTime<Local>,
    pub listen_ip: String,
    pub listen_port: u16,
}

impl HelloResponse {
    pub fn to_html(self) -> String {
        return String::new()
            .add("<div>")
            .add("<p>")
            .add("Current IP Address is: ")
            .add(&*self.ip)
            .add("</p>")
            .add("<p>")
            .add("Current time for your timezone: ")
            .add(&*self.current_time)
            .add("</p>")
            .add("</div>");
    }
}
