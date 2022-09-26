import { useField, Field } from "formik";
import React from "react";
import PhoneInput from "react-phone-input-2";
import "react-phone-input-2/lib/style.css";

const modifyClasses = (className, meta) => {
  if (meta.touched) {
    let isInvalid = meta.error;
    if (isInvalid && !className.includes("is-invalid"))
      className = className + " is-invalid";
    if (!isInvalid && !className.includes("is-valid"))
      className = className + " is-valid";
  }
  return className;
};

export const TextInput = ({
  label,
  labelClassname = "form-label",
  isRequired = false,
  ...props
}) => {
  const [field, meta] = useField(props);

  props.className = modifyClasses(props.className, meta);

  return (
    <>
      {label && (
        <label htmlFor={props.id || props.name} className={labelClassname}>
          {label}
          {isRequired && <span style={{ color: "#E67A66" }}>*</span>}
        </label>
      )}
      <Field {...field} {...props} />
      {meta.touched && meta.error ? (
        <div className="invalid-feedback text-red-500 text-sm py-2">
          {meta.error}
        </div>
      ) : null}
    </>
  );
};

export const PhoneInputComp = ({
  label = "Your Telephone Number",
  labelClassname = "form-label",
  placeholder,
  onChange,
  errors,
  isRequired = false,
  ...props
}) => {
  const [field, meta, helpers] = useField(props);
  const { setValue } = helpers;
  props.className = modifyClasses(props.className, meta);

  return (
    <>
      <label htmlFor={props.id || props.name} className={labelClassname}>
        {label}
        {isRequired && <span style={{ color: "#E67A66" }}>*</span>}
      </label>
      <PhoneInput
        value={props.value}
        country={"no"}
        inputClass={props.className}
        inputStyle={{ width: "100%", height: "48px" }}
        inputProps={{
          name: field.name,
          onBlur: field.onBlur,
        }}
        onChange={(phone) => setValue(phone)}
      />
      {meta.error ? (
        <div
          className="invalid-feedback invalid-feedback text-red-500 text-sm py-2"
          style={{ display: meta.error && meta.touched ? "block" : "none" }}
        >
          {meta.error}
        </div>
      ) : null}
    </>
  );
};

export const PasswordInput = ({
  label,
  labelClassname = "form-label",
  isRequired = false,
  ...props
}) => {
  const [field, meta] = useField(props);

  props.className = modifyClasses(props.className, meta);

  const [type, setType] = React.useState("password");

  return (
    <>
      {label && (
        <label htmlFor={props.id || props.name} className={labelClassname}>
          {label}
          {isRequired && <span style={{ color: "#E67A66" }}>*</span>}
        </label>
      )}
      <div className="input-group" id="show_hide_password">
        <Field {...field} {...props} type={type} autoComplete="on" />
        <div className="input-group-addon cp">
          <span
            style={{
              fontSize: "12px",
              lineHeight: "16px",
              marginRight: meta.touched ? "15px" : "0px",
            }}
            onClick={() =>
              setType((type) => (type === "password" ? "text" : "password"))
            }
          >
            {type === "password" ? "Show" : "Hide"}
          </span>
        </div>
        {meta.touched && meta.error ? (
          <div className="invalid-feedback invalid-feedback text-red-500 text-sm py-2">
            {meta.error}
          </div>
        ) : null}
      </div>
    </>
  );
};
