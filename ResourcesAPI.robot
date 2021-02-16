*** Settings ***
Documentation   Documentação da API: https://fakerestapi.azurewebsites.net/api/v1/Books
Library         RequestsLibrary
Library         Collections

*** Variables ***
${URL_API}      https://fakerestapi.azurewebsites.net/api/v1
&{BOOK_15}      id=15
...             title=Book 15
...             pageCount=1500
&{BOOK_3000}    id=3000
...             title=Testes
...             description=Testando Testes
...             pageCount=200
...             excerpt=testesteste
...             publishDate=2021-02-16T18:29:51.344Z

&{BOOK_3000_EDIT}   title=Livro dos Testes Testados
...                 description=Mudando a descricao


*** Keywords ***
Conectar na API
    Create Session      fakeAPI         ${URL_API}
    ${HEADERS}     Create Dictionary    content-type=application/json
    Set Suite Variable    ${HEADERS}

Requisitar todos os livros
    ${RESPOSTA}         Get On Session     fakeAPI     Books
    Log                 ${RESPOSTA.text}
    Set Test Variable   ${RESPOSTA}

Requisitar o livro "${ID_LIVRO}"    
   ${RESPOSTA}         Get On Session     fakeAPI     Books/${ID_LIVRO}
    Log                 ${RESPOSTA.text}
    Set Test Variable   ${RESPOSTA}

Cadastrar um novo livro
    ${RESPOSTA}         Post On Session     fakeAPI     Books
    ...                 data={"id": ${BOOK_3000.id},"title": "${BOOK_3000.title}", "description": "${BOOK_3000.description}","pageCount": ${BOOK_3000.pageCount}, "excerpt": "${BOOK_3000.excerpt}","publishDate": "${BOOK_3000.publishDate}"}
    ...                 headers=${HEADERS}
    Log                 ${RESPOSTA.text}
    Set Test Variable   ${RESPOSTA}

Alterar o livro "${ID_LIVRO}"
    ${RESPOSTA}    Put On Session    fakeAPI    Books/${ID_LIVRO}
    ...                           data={"id": ${BOOK_3000.id},"title": "${BOOK_3000_EDIT.title}", "description": "${BOOK_3000_EDIT.description}","pageCount": ${BOOK_3000.pageCount}, "excerpt": "${BOOK_3000.excerpt}", "publishDate": "${BOOK_3000.publishDate}"}
    ...                           headers=${HEADERS}
    Log            ${RESPOSTA.text}
    Set Test Variable    ${RESPOSTA}

Deletar o livro "${ID_LIVRO}"
    ${RESPOSTA}   Delete On Session  fakeAPI   Books/${ID_LIVRO}
    Log            ${RESPOSTA.text}
    Set Test Variable    ${RESPOSTA}
    
Conferir o status
    [Arguments]     ${STATUS_ESPERADO}
    Should Be Equal As Strings  ${RESPOSTA.status_code}  ${STATUS_ESPERADO}

Conferir o reason
    [Arguments]     ${REASON_ESPERADO}
    Should Be Equal As Strings  ${RESPOSTA.reason}      ${REASON_ESPERADO}

Conferir se retorna uma lista com "${QUANTIDADE}" livros    
   Length Should Be   ${RESPOSTA.json()}     ${QUANTIDADE}

Conferir se retorna todos os dados cadastrados do livro "${ID_LIVRO}"
   Conferir dados do livro  "${ID_LIVRO}"

Conferir se retorna todos os dados que foram alterados do livro "${ID_LIVRO}"
   Conferir dados do livro editados    "${ID_LIVRO}"

Conferir se a descrição não está vazia 
    Dictionary Should Contain Item  ${RESPOSTA.json()}  id         ${BOOK_15.id}
    Dictionary Should Contain Item  ${RESPOSTA.json()}  title      ${BOOK_15.title}
    Dictionary Should Contain Item  ${RESPOSTA.json()}  pageCount  ${BOOK_15.pageCount}
    Should Not Be Empty             ${RESPOSTA.json()["description"]}
    Should Not Be Empty             ${RESPOSTA.json()["excerpt"]}
    Should Not Be Empty             ${RESPOSTA.json()["publishDate"]} 

Conferir se deleta o livro "${ID_LIVRO}"
   Should Be Empty            ${RESPOSTA.content}

Conferir dados do livro
    [Arguments]     ${ID_LIVRO}
    Dictionary Should Contain Item    ${RESPOSTA.json()}    id              ${BOOK_3000.id}
    Dictionary Should Contain Item    ${RESPOSTA.json()}    title           ${BOOK_3000.title}
    Dictionary Should Contain Item    ${RESPOSTA.json()}    description     ${BOOK_3000.description}
    Dictionary Should Contain Item    ${RESPOSTA.json()}    pageCount       ${BOOK_3000.pageCount}
    Dictionary Should Contain Item    ${RESPOSTA.json()}    excerpt         ${BOOK_3000.excerpt}
    Dictionary Should Contain Item    ${RESPOSTA.json()}    publishDate     ${BOOK_3000.publishDate}

Conferir dados do livro editados
    [Arguments]     ${ID_LIVRO}
    Dictionary Should Contain Item    ${RESPOSTA.json()}    title           ${BOOK_3000_EDIT.title}
    Dictionary Should Contain Item    ${RESPOSTA.json()}    description     ${BOOK_3000_EDIT.description}