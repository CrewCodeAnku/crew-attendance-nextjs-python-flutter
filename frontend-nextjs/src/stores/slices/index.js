import { combineReducers } from "@reduxjs/toolkit";
import { userslice } from "./user";
import { appslice } from "./app";
import { studentslice } from "./student";
import { teacherslice } from "./teacher";
import createCompressor from "redux-persist-transform-compress";
import encryptor from "./encryptor";
import storage from "redux-persist/lib/storage";
import { persistReducer } from "redux-persist";

const reducers = combineReducers({
  user: userslice.reducer,
  app: appslice.reducer,
  student: studentslice.reducer,
  teacher: teacherslice.reducer,
});

const compressor = createCompressor();

const config = {
  blacklist: ["app", "network", "toast"],
  key: "primary",
  storage,
  transforms: [encryptor, compressor],
};

export const persistedReducer = persistReducer(config, reducers);
