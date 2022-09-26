import { all } from "redux-saga/effects";
import user from "./user";
import student from "./student";
import teacher from "./teacher";

const sagas = function* sagas() {
  yield all([user(), student(), teacher()]);
};

export default sagas;
