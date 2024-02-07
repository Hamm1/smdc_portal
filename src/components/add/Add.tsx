
import { $, component$, useSignal} from '@builder.io/qwik';
import { invoke } from '@tauri-apps/api/tauri';
import Swal from 'sweetalert2';

interface Location {
    title: string;
    url: string;
}

export default component$(() => {
    const title = useSignal('');
    const url = useSignal('');

    const sweet_alert = $(async (title: string) => {
        const Toast = Swal.mixin({
            toast: true,
            position: "top-end",
            showConfirmButton: false,
            timer: 3000,
            timerProgressBar: true,
            didOpen: (toast) => {
              toast.onmouseenter = Swal.stopTimer;
              toast.onmouseleave = Swal.resumeTimer;
            }
          });
          Toast.fire({
            icon: "error",
            title: title,
            background: "#2f2f2f",
            color: "#ffffff"
          });
    })

    const submit_button = $(async () => {
        if (title.value !== '' && url.value !== '' && url.value.includes("https://") && url.value.includes(".smdc.army.mil")){
            const json_from_submit: Location = {title:title?.value,url:url?.value}
            const new_json: string = JSON.stringify(json_from_submit)
            const v = await invoke('get_additional_variables', {qwik: new_json})
            console.log(v);
            (document.getElementById("dialog") as HTMLDialogElement).close() as any
            window.location.reload()
        } else if(title.value === '') {
            sweet_alert("Title can not be blank")
        } else if(url.value === '') {
            sweet_alert("URL can not be blank")
        } else if(!url.value.includes("https://")){
            sweet_alert("URL Must contain https://")
        } else if(!url.value.includes(".smdc.army.mil")){
            sweet_alert("URL Must contain .smdc.army.mil")
        }
      })

      return (
        <>
            <div>
                <div>
                    <button class="btn m-5 float-right mt-5 ml-auto" onClick$={() => (document.getElementById("dialog") as HTMLDialogElement).showModal() as any}>
                        ADD
                    </button>
                </div>
                <dialog id="dialog" class="modal">
                    <div class="modal-box">
                        <h3 class="font-bold text-lg">Links</h3>
                        <p class="py-4">Add a Title and URL, the URL must contain https:// and be a smdc domain.</p>
                        <input type="text" placeholder="Title..." class="input input-bordered w-full max-w-xs m-3" onInput$={(e) => title.value = (e.target as HTMLInputElement).value} />
                        <input type="text" placeholder="URL..." class="input input-bordered w-full max-w-xs m-3" onInput$={(e) => url.value = (e.target as HTMLInputElement).value} />
                        <button class="btn btn-info btn-outline m-3" onClick$={() => submit_button()}>
                            Submit
                        </button>
                        <button class="btn btn-sm btn-circle btn-ghost absolute right-2 top-2" onClick$={() => (document.getElementById("dialog") as HTMLDialogElement).close() as any}>✕</button>
                    </div>
                    <form method="dialog" class="modal-backdrop">
                        <button>close</button>
                    </form>
                </dialog>
            </div>
        </>
      )
})