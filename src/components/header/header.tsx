import { component$ } from "@builder.io/qwik";
// import { SMDCLogo } from "../icons/smdc";
import styles from "./header.module.css";
import { Window } from '@tauri-apps/api/window'
import { Webview} from "@tauri-apps/api/webview";

export default component$(() => {
  return (
    <header class={styles.header}>
      <div class={["container", styles.wrapper]}>
        <div class={styles.logo}>
          <a href="/" title="SMDC">
            {/* <SMDCLogo height={206} width={271} /> */}
            <img src="../../../smdc_squared.png" width={200} height={200}/>
          </a>
        </div>
        <ul>
          <li>
            <a
              href="#"
              class=" text-slate-900 hover:text-slate-400 dark:text-white"
              onClick$={() => {
                new Webview((new Window("Documentation")),"helpdesktool", {
                    url: "https://helpdesktool.smdch.smdc.army.mil",
                    height: 800,
                    width: 1200,
                    x: 0,
                    y: 0
                })
              }}
            >
              Documentation
            </a>
          </li>
          <li>
            <a
              href="#"
              class=" text-slate-900 hover:text-slate-400 dark:text-white"
              onClick$={() => {
                new Webview((new Window("KMST")),"kmst", {
                    url: "https://kmst.smdc.army.mil/",
                    height: 800,
                    width: 1200,
                    x: 0,
                    y: 0
                })
              }}
            >
              KMST
            </a>
          </li>
          <li>
            <a
              href="#"
              class=" text-slate-900 hover:text-slate-400 dark:text-white"
              onClick$={() => {
                new Webview((new Window("Sharepoint")),"Sharepoint", {
                    url: "https://armyeitaas.sharepoint-mil.us/sites/USASMDC",
                    height: 800,
                    width: 1200,
                    x: 0,
                    y: 0
                })
              }}
            >
              Sharepoint
            </a>
          </li>
        </ul>
      </div>
    </header>
  );
});
