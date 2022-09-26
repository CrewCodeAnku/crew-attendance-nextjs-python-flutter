import axios from "axios";
import Idx from "idx";

const AxiosInstance = axios.create({
  withCredentials: true,
  baseURL: `${process.env.NEXT_PUBLIC_API_URL}`,
  headers: {
    Accept: "application/json",
    "Content-Type": "multipart/form-data",
  },
  timeout: 1000 * 60 * 2,
});

AxiosInstance.interceptors.request.use(
  (config) => config,
  (error) => Promise.reject(error)
);

AxiosInstance.interceptors.response.use(
  (response) => response,
  (error) => {
    if (Idx(error, (_) => _.response.data)) {
      const errorDetail = {
        code: error.response.status,
        message: error.response.data.message,
      };

      return Promise.reject(errorDetail);
    }

    return Promise.reject(error);
  }
);

export default AxiosInstance;
