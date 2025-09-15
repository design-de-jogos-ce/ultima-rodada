# Instruções sobre Git e o Projeto

Algumas instruções sobre o git e o projeto no geral:

1.  Fica **uma pessoa por branch**, pra evitar conflito e `git merge` desnecessário.
2.  Vamos tentar identificar no nome da branch só pra que é aquela branch e qual a categoria dela (feature, bugfix e afins) seguindo o padrão:
    `feat/nome-da-task`
3.  Caso alguém queira mexer na branch do amiguinho para resolver algo, é bom deixar a **comunicação alinhada** com o amiguinho para evitar conflitos também.
4.  Por precaução, vai entrar no projeto? Use um `git pull` antes, mesmo que você (acha que) tenha certeza que ninguém mexeu. Vai que o coleguinha mexe na tua branch e não avisa.
5.  Caso alguém queira subir algo para a `main`, há um padrão a seguir:
    * Na sua branch, use: `git merge main`, para atualizar sua branch.
    * Na branch `main`, utilize: `git merge feat/nome-da-task`.

    > *Caso alguém não se sinta seguro com merge, só me chamar, dá certo.*

---

## Comandos Mais Utilizados

-   `git checkout nome-da-branch`
    -   Para trocar de branch.
-   `git merge nome-da-outra-branch`
    -   Para adicionar as modificações de `nome-da-outra-branch` na branch em que você está.
-   `git checkout -b nome-da-nova-branch`
    -   Para criar uma nova branch a partir da que você está atualmente.
-   `git pull`
    -   Para atualizar sua branch local de acordo com a branch remota.
