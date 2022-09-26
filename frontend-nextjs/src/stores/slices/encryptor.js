import { encryptTransform } from "redux-persist-transform-encrypt";

const encryptor = encryptTransform({
  secretKey: "my-super-secret-key-boilerplate",
});

export default encryptor;
