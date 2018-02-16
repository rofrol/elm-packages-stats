#![feature(plugin)]
#![plugin(rocket_codegen)]

extern crate rocket;
extern crate rocket_cors;

use rocket::http::Method;
use rocket_cors::{AllowedOrigins, AllowedHeaders};

#[get("/")]
fn index() -> &'static str {
    "[
       { \"date\": \"2017-02-15\", \"count\": 255},
       { \"date\": \"2017-02-14\", \"count\": 253},
       { \"date\": \"2017-02-13\", \"count\": 246},
       { \"date\": \"2017-02-12\", \"count\": 240},
       { \"date\": \"2017-02-11\", \"count\": 237}
    ]"
}

fn main() {
    let (allowed_origins, failed_origins) = AllowedOrigins::some(&["http://localhost:8000"]);
    assert!(failed_origins.is_empty());

    // You can also deserialize this
    let options = rocket_cors::Cors {
        allowed_origins: allowed_origins,
        allowed_methods: vec![Method::Get].into_iter().map(From::from).collect(),
        allowed_headers: AllowedHeaders::some(&["Authorization", "Accept"]),
        allow_credentials: true,
        ..Default::default()
    };



    rocket::ignite()
        .mount("/", routes![index])
        .attach(options)
        .launch();
}