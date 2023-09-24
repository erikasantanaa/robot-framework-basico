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
    [Arguments]    ${mail}    ${status_code_desejado}
    ${body}    Create Dictionary
    ...    nome=Fulano da Silva
    ...    email=${mail}
    ...    password=123456
    ...    administrador=true
    Log    ${body}

    Criar Sessão base na ServeRest

    # POST
    ${resposta}    POST On Session
    ...    alias=ServeRest
    ...    url=/usuarios
    ...    json=${body}
    ...    expected_status=${status_code_desejado}
    
    #variavel global
    # OBS: ERRO no IF, verificar
    Log    ${resposta.json()}
    
    IF    ${resposta.status_code}  ===  201        
        Set Test Variable    ${ID_USUARIO}    ${resposta.json()["_id"]}
    END

    Set Test Variable    ${RESPOSTA}    ${resposta.json()}

# Collections
Conferir se o usuário foi cadastrado corretamente
    Log    ${RESPOSTA}
    # OBS: Verificar esse erro, quando executa essas duas Keywords Dictionary: 
    # ...   [FAIL INSIDE] TypeError: Expected argument 1 to be a dictionary or dictionary-like, got method instead.
    
    Dictionary Should Contain Item    ${RESPOSTA}    message    cadastrado realizado com sucesso
    Dictionary Should Contain Key    ${RESPOSTA}    _id

Vou repetir o cadastrado do usuário
    Cadastrar o usuário criado na ServeRest    email=${EMAIL_TEST}    status_code_desejado=400
    
Verificar se a API não permitiu o cadastro repetido
    Dictionary Should Contain Item    ${RESPOSTA}    message    Este email já está sendo usado

Consultar os dados do novo usuário
    #utilizando any em expected, ele nao consefere o status, se colocar 200 ele verifica o status
    ${resposta_consulta}    GET On Session    alias=ServeRest    url=/usuarios/${ID_USUARIO}    expected_status=any
    Log    ${resposta_consulta.status_code}
    Log    ${resposta_consulta.reason}
    Log    ${resposta_consulta.headers}
    Log    ${resposta_consulta.elapsed}
    Log    ${resposta_consulta.text}
    Log    ${resposta_consulta.json()}

    Set Test Variable    ${RESP_CONSULTA}    ${resposta_consulta.json()}

Conferir os dados retornados
    Log    ${RESP_CONSULTA}
    Dictionary Should Contain Item    ${RESP_CONSULTA}    nome            Fulano da Silva
    Dictionary Should Contain Item    ${RESP_CONSULTA}    email           ${EMAIL_TEST}
    Dictionary Should Contain Item    ${RESP_CONSULTA}    password        1234
    Dictionary Should Contain Item    ${RESP_CONSULTA}    administrador   true
    Dictionary Should Contain Item    ${RESP_CONSULTA}    _id             ${ID_USUARIO}

