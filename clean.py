import os
import shutil

def clean(path):
  if os.path.exists(path):
    try:
      shutil.rmtree(path)
    except:
      os.remove(path)

if os.name == "posix":
  print("Linux or MacOS")
  remove = ["./node_modules","./dist","./server","./src-tauri/target",
            "./bun.lockb","./package-lock.json","./tmp","./src-tauri/Cargo.lock"]
  for r in remove:
    clean(r)

if os.name == "nt":
  print("Windows")
  remove = [".\\node_modules",".\\dist",".\\server",".\\src-tauri\\target",
            ".\\bun.lockb",".\\package-lock.json",".\\tmp",".\\src-tauri\\Cargo.lock"]
  for r in remove:
    clean(r)
