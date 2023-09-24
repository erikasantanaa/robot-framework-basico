*** Settings ***
Library    RequestsLibrary
Library    String
Library    OperatingSystem
Library    Collections

*** Keywords ***
#url base: com dados solicitados da api
Criar Sessão base na ServeRest 
    ${headers}    Create Dictionary    accept=application/json    Content-Type=application/json
    Create Session    alias=ServeRest    url=https://serverest.dev/    headers=${headers}

Criar um usuário novo
    ${palavra_aleatoria}    Generate Random String    length=4    chars=[LETTERS]
    ${palavra_aleatoria}    Convert To Lower Case     ${palavra_aleatoria}
    Set Test Variable       ${EMAIL_TEST}    ${palavra_aleatoria}@emailteste.com
    Log    ${EMAIL_TEST}

Cadastrar o usuário criado na ServeRest
    ${body}    Create Dictionary
    ...    nome=Fulano da Silva
    ...    email=${EMAIL_TEST}
    ...    password=123456
    ...    administrador=true
    Log    ${body}
    Criar Sessão base na ServeRest
    # POST
    ${resposta}    POST On Session
    ...    alias=ServeRest
    ...    url=/usuarios
    ...    json=${body}
    
    Log    ${resposta.json()}
    #variavel global
    Set Test Variable    ${RESPOSTA}    ${resposta.json}

# Collections
Conferir se o usuário foi cadastrado corretamente
    Log    ${RESPOSTA}
    Dictionary Should Contain Item    ${RESPOSTA}    message    Cadastro realizado com sucesso