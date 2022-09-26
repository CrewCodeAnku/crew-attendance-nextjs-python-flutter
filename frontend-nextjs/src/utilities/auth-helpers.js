import nextCookie from "next-cookies";
import cookie from "js-cookie";
import Router from "next/router";

export const auth = (ctx, layout = "private", access = false) => {
  if (ctx && ctx.req && !ctx.req.headers) {
    return null;
  }
  const { isLoggedIn, role } = nextCookie(ctx);

  if (!isLoggedIn && layout === "private" && !access) {
    console.log("Inside private access");
    ctx.res.writeHead(302, { Location: "/" });
    ctx.res.end();
    return null;
  }

  if (isLoggedIn && layout === "public" && role === "guest") {
    return null;
  }

  if (!isLoggedIn && layout === "private" && role === "guest") {
    ctx.res.writeHead(302, { location: "/" });
    ctx.res.end();

    return null;
  }

  if (isLoggedIn && layout === "public" && role === "student") {
    ctx.res.writeHead(302, { Location: "/dashboard" });
    ctx.res.end();
    return null;
  }

  if (isLoggedIn && layout === "public" && role === "student") {
    Router.push("/dashboard");
  }

  if (isLoggedIn && layout === "public" && role === "teacher") {
    ctx.res.writeHead(302, { Location: "/dashboard" });
    ctx.res.end();

    return null;
  }

  if (isLoggedIn && layout === "public" && role === "teacher") {
    Router.push("/dashboard");
  }
};

export const setCookies = (status) => {
  if (status) {
    cookie.set("isLoggedIn", status);
  } else {
    cookie.remove("isLoggedIn");
    cookie.remove("role");

    Object.keys(cookie.get()).forEach((cookieName) => {
      cookie.remove(cookieName);
    });
  }
};
