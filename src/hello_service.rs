use crate::model::HelloResponse;
use actix_web::{get, HttpRequest, HttpResponse, Responder};
use chrono::{DateTime, Local, TimeZone, Utc};
use chrono_tz::Tz;

#[get("/")]
pub(crate) async fn hello(req: HttpRequest) -> impl Responder {
    let connection = req.connection_info().to_owned();
    let ip = connection
        .realip_remote_addr()
        .expect("Unable to get IP address.")
        .clone();

    let time: String = match ip {
        "127.0.0.1" | "0.0.0.0" | "localhost" => {
            let local: DateTime<Local> = Local::now();
            local.to_string()
        }
        &_ => {
            let location = geolocation::find(ip.clone()).expect("Unable to get location.");
            let mut tz_str = location.timezone.clone();
            tz_str.remove(0);
            tz_str.remove(tz_str.len() - 1);
            let tz: Tz = tz_str.clone().parse().unwrap();
            tz.from_utc_datetime(&Utc::now().naive_utc()).to_string()
        }
    };

    HttpResponse::Ok().body(
        HelloResponse {
            ip: ip.to_string(),
            current_time: time,
        }
        .to_html(),
    )
}
