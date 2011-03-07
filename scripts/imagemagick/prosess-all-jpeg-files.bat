for  {each item} in {a collection of items}  do {command}
for %%X in (*.jpg) do command
for /d %%X in (directorySet) do command
for /r [parent directory] %%X in (set) do command


for /r D:\vanhat-kuvat %%X in (*.jpg) do (fred.sh %%X)
