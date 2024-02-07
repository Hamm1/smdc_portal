import { component$ } from "@builder.io/qwik";
// import { SMDCLogo } from "../icons/smdc";
import styles from "./header.module.css";
import { WebviewWindow } from "@tauri-apps/api/webview";

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
              onClick$={() => {
                new WebviewWindow("helpdesktool", {
                    title: "Documentation",
                    url: "https://helpdesktool.smdch.smdc.army.mil",
                    height: 800,
                    width: 1200
                })
              }}
            >
              Documentation
            </a>
          </li>
          <li>
            <a
              href="#"
              onClick$={() => {
                new WebviewWindow("kmst", {
                    title: "KMST",
                    url: "https://kmst.smdc.army.mil/",
                    height: 800,
                    width: 1200
                })
              }}
            >
              KMST
            </a>
          </li>
          <li>
            <a
              href="#"
              onClick$={() => {
                new WebviewWindow("Sharepoint", {
                    title: "Sharepoint",
                    url: "https://armyeitaas.sharepoint-mil.us/sites/USASMDC",
                    height: 800,
                    width: 1200
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
