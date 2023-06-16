# Sprawozdanie

## 1. Część obowiązkowa

<i>
Utworzono workflow w github actions o nazwie gha_build_and_push.yml.
</i>


### a. Budowa pliku workflow
<i>
Workflow składa się z jednego zadania nazwanego build-push-images uruchamiającego się na systemie ubuntu.
W pliku zdefiniowano dwa punkty wejściowe.
Plik składa się z 5 kroków.
</i>

### b. Zadania spełniane przez workflow
<i>
Głównym celem jest zbudowanie obrazu opisanego w Dockerfile-multi.
Obraz zapisywany jest w repozytorium dockerhub.
</i>

### c. Zdefiniowane etapy
<ol>
<li>Pobranie kodu z repozytorium</li>
<li>Instalacja QEMU</li>
<li>Instalacja buildx</li>
<li>Uwierzytelnienie w dockerhub</li>
<li>Budowa obrazu na podstawie Dockerfile-multi</li>
</ol>

## Wnioski
<i>
Tworzenie aplikacji w github actions jest bardzo intuicyjne, 
łatwo jest zacząć, a baza dostępnych gotowych rozwiązań jest bardzo duża.
</i>