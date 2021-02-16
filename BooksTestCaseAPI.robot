*** Settings ***
Documentation   Documentação da API: https://fakerestapi.azurewebsites.net/api/v1/Books
Resource        ResourcesAPI.robot
Suite Setup     Conectar na API

*** Test Cases ***
Buscar a lista com todos os livros
    Requisitar todos os livros
    Conferir o status   200
    Conferir o reason   OK
    Conferir se retorna uma lista com "200" livros

Buscar um livro específico
    Requisitar o livro "15"
    Conferir o status   200
    Conferir o reason   OK 
    Conferir se a descrição não está vazia

Cadastrar um novo livro
    Cadastrar um novo livro
    Conferir se retorna todos os dados cadastrados do livro "3000"

Alterar um livro específico
    Alterar o livro "3000"
    Conferir se retorna todos os dados que foram alterados do livro "3000"

Deletar um livro específico
    Deletar o livro "3000"
    Conferir se deleta o livro "3000"
