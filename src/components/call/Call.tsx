
import { $, component$, useVisibleTask$, useSignal, useStore} from '@builder.io/qwik';
import { invoke } from '@tauri-apps/api/core';
// import { Window } from '@tauri-apps/api/window'
// import { Webview } from "@tauri-apps/api/webview";
import { v4 as uuidv4 } from 'uuid';
import { WebviewWindow } from '@tauri-apps/api/webviewWindow';

interface Location {
    id: string,
    title: string;
    url: string;
    removable: boolean
}

interface Locations {
    locations: Array<Location>
}

export default component$(() => {
    const paths = useSignal('[]')
    const state = useStore<Locations>({ locations: [] });
    const search = useSignal('');

    const path_collection = $(async () => {
        paths.value = await invoke('get_location_variables')
        const parsed_config: Locations = JSON.parse(paths.value);
        console.log(parsed_config);
        console.log(parsed_config.locations[0].url);
        state.locations = parsed_config.locations
    })
    
    // eslint-disable-next-line qwik/no-use-visible-task
    useVisibleTask$(async () => {
        await path_collection()
    });

    return (
        <>
            <input id="search_field" type="text" placeholder="Search..." class="input input-bordered w-full max-w-xs m-5" onInput$={(e) => search.value = (e.target as HTMLInputElement).value} />
            {search.value != '' ?
                <button class="btn btn-square btn-outline btn-error" onClick$={() => {
                        search.value = '';
                        (document.getElementById('search_field') as HTMLInputElement).select();
                        (document.getElementById('search_field') as HTMLInputElement).value = ''
                    }} >
                    ✕
                </button>
                : <></>
            }
            <ul role="list" class="grid grid-cols-2 2xl:grid-cols-4 3xl:grid-cols-6 gap-3">
            {state.locations.filter((record) => record.title.toLowerCase().includes(search.value.toLowerCase())).map((record) => {
                return (
                    <div class="card w-96 bg-primary text-primary-content" key={record.title}>
                        <div class="card-body">
                            <h2 class="card-title">{record.title}</h2>
                            <p class="break-words text-wrap">{record.url}</p>
                            <div class="card-actions justify-end">
                                <button class="btn" onClick$={() => {
                                    new WebviewWindow(uuidv4(), {
                                        incognito: true,
                                        title: record.title,
                                        url: record.url,
                                        height: 800,
                                        width: 1200
                                    })
                                }}>Link
                                </button>
                                {record.removable ?
                                    <button class="btn" onClick$={async () => {
                                            await invoke('get_additional_variables_remove', {id: record.id});
                                            await path_collection();
                                        }
                                    }>Delete
                                    </button>
                                 : <></>}
                            </div>
                        </div>
                    </div>
                )
            })
            }
        </ul>
        </>
    );
});
