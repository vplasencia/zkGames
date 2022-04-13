/** @type {import('next').NextConfig} */
const withPWA = require("next-pwa");
const nextConfig = {
  reactStrictMode: true,
  webpack: function (config, options) {
    if (!options.isServer) {
      config.resolve.fallback.fs = false;
    }
    config.experiments = { asyncWebAssembly: true };
    return config;
  },
  pwa: {
    disable: process.env.NODE_ENV === "development",
    dest: "public",
  },
};

module.exports = withPWA(nextConfig);
