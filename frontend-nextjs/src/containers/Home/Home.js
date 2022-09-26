import React from "react";
import classes from "./Home.module.css";
import { useRouter } from "next/router";

const Home = (props) => {
  const router = useRouter();

  return (
    <React.Fragment>
      <section className={`${classes.hero} d-flex align-items-center`}>
        <div className="container">
          <div className="row">
            <div className="col-lg-6 pt-4 pt-lg-0 order-2 order-lg-1 d-flex flex-column justify-content-center">
              <h1>Redux saga Boilerplate</h1>
              <h2>
                Using this boilerplate you can customize your code and built web
                app in react, redux and saga{" "}
              </h2>
              <div>
                <button
                  type="button"
                  onClick={(e) => {
                    e.preventDefault();
                    router.push("/signup");
                  }}
                  style={{ height: "auto" }}
                  className={`btn app-btn scrollto mt-3`}
                >
                  Get Started
                </button>
              </div>
            </div>
            <div className="col-lg-6 order-1 order-lg-2 hero-img">
              <img
                src={"/staic/images/hero-img.png"}
                className="img-fluid"
                alt=""
              />
            </div>
          </div>
        </div>
      </section>
    </React.Fragment>
  );
};

export default Home;
