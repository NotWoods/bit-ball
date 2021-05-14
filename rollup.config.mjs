// @ts-check
import commonjs from "@rollup/plugin-commonjs";
import json from '@rollup/plugin-json';
import resolve from "@rollup/plugin-node-resolve";
import replace from "@rollup/plugin-replace";
import typescript from "@rollup/plugin-typescript";
import serve from "rollup-plugin-serve";
import { terser } from "rollup-plugin-terser";

/**
 * @returns {import('rollup').RollupOptions}
 */
export default function makeConfig() {
  const isProduction = process.env.NODE_ENV === "production";

  return {
    //  Our games entry point (edit as required)
    input: "./js/game.ts",

    //  Where the build file is to be generated.
    //  Most games being built for distribution can use iife as the module type.
    //  You can also use 'umd' if you need to ingest your game into another system.
    //  The 'intro' property can be removed if using Phaser 3.21 or above. Keep it for earlier versions.
    output: {
      file: "./dist/game.js",
      name: "BitBall",
      format: "iife",
      sourcemap: !isProduction,
      banner: "var global = window;",
    },

    plugins: [
      //  Toggle the booleans here to enable / disable Phaser 3 features:
      replace({
        "typeof CANVAS_RENDERER": JSON.stringify(true),
        "typeof WEBGL_RENDERER": JSON.stringify(true),
        "typeof EXPERIMENTAL": JSON.stringify(true),
        "typeof PLUGIN_CAMERA3D": JSON.stringify(false),
        "typeof PLUGIN_FBINSTANT": JSON.stringify(false),
        "typeof FEATURE_SOUND": JSON.stringify(true),
      }),

      //  Parse our .ts source files
      resolve({
        extensions: [".ts", ".tsx"],
      }),

      json(),

      //  We need to convert the Phaser 3 CJS modules into a format Rollup can use:
      commonjs({
        include: ["node_modules/eventemitter3/**", "node_modules/phaser/**"],
        exclude: ["node_modules/phaser/src/polyfills/requestAnimationFrame.js"],
        sourceMap: !isProduction,
        ignoreGlobal: true,
      }),

      //  See https://www.npmjs.com/package/rollup-plugin-typescript2 for config options
      typescript(),

      //  See https://www.npmjs.com/package/rollup-plugin-serve for config options
      !isProduction &&
        serve({
          open: true,
          contentBase: ["dist", "static"],
          host: "localhost",
          port: 10001,
          headers: {
            "Access-Control-Allow-Origin": "*",
          },
        }),

      isProduction && terser(),
    ],
  };
}
