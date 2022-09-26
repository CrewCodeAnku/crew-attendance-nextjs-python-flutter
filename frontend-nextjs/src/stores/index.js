//import { routerMiddleware } from "connected-react-router";
import { configureStore } from "@reduxjs/toolkit";
import createSagaMiddleware from "redux-saga";
import { persistedReducer } from "./slices";
import rootSaga from "./sagas";

export default function configureMainStore() {
  const sagaMiddleware = createSagaMiddleware();
  const store = configureStore({
    reducer: persistedReducer,
    middleware: (getDefaultMiddleware) =>
      getDefaultMiddleware({
        serializableCheck: false,
      }).concat(sagaMiddleware),
    devTools: process.env.NODE_ENV !== "production",
  });
  sagaMiddleware.run(rootSaga);
  return { store };
}
