#![allow(warnings)] // remove when error_chain is fixed

extern crate reqwest;
extern crate env_logger;
extern crate serde_json;

#[macro_use]
extern crate error_chain;

use serde_json::{Value, Error as SerdeJsonError};
use std::io::Read;

error_chain! {
    foreign_links {
        ReqError(reqwest::Error);
        IoError(std::io::Error);
        SerdeJsonError(SerdeJsonError);
    }
}

fn run() -> Result<()> {
    env_logger::init();

    let mut res = reqwest::get("http://package.elm-lang.org/new-packages")?;

    let mut buffer = String::new(); 
    res.read_to_string(&mut buffer)?;
    let v: Value = serde_json::from_str(&buffer)?;

    if let Value::Array(val) = v {
        println!("{}", val.len());
    }

    Ok(())
}

quick_main!(run);