import { component$ } from '@builder.io/qwik';
// import { SMDCLogo } from "../icons/smdc";
import styles from './header.module.css';
// import { Window } from '@tauri-apps/api/window'
// import { Webview} from "@tauri-apps/api/webview";
import { WebviewWindow } from '@tauri-apps/api/webviewWindow';

export default component$(() => {
  return (
    <header class={styles.header}>
      <div class={['container', styles.wrapper]}>
        <div class={styles.logo}>
          <a href="/" title="SMDC">
            {/* <SMDCLogo height={206} width={271} /> */}
            <img class={styles.responsive_image} src="../../../smdc_squared.png" />
          </a>
        </div>
        <ul>
          <li>
            <a
              href="#"
              class=" text-slate-900 2xl:text-lg hover:text-slate-400 dark:text-white"
              onClick$={() => {
                new WebviewWindow('Documentation', {
                  incognito: true,
                  title: 'Documentation',
                  url: 'https://helpdesktool.smdch.smdc.army.mil',
                  height: 800,
                  width: 1200,
                });
              }}>
              Documentation
            </a>
          </li>
          <li>
            <a
              href="#"
              class=" text-slate-900 2xl:text-lg hover:text-slate-400 dark:text-white"
              onClick$={() => {
                new WebviewWindow('KMST', {
                  incognito: true,
                  title: 'KMST',
                  url: 'https://kmst.smdc.army.mil/',
                  height: 800,
                  width: 1200,
                });
              }}>
              KMST
            </a>
          </li>
          <li>
            <a
              href="#"
              class=" text-slate-900 2xl:text-lg hover:text-slate-400 dark:text-white"
              onClick$={() => {
                new WebviewWindow('Sharepoint', {
                  incognito: true,
                  title: 'Sharepoint',
                  url: 'https://armyeitaas.sharepoint-mil.us/sites/USASMDC',
                  height: 800,
                  width: 1200,
                });
              }}>
              Sharepoint
            </a>
          </li>
        </ul>
      </div>
    </header>
  );
});
