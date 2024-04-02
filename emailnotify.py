from azure.communication.email import EmailClient
import sys

def main():
    email = sys.argv[2]
    constr = sys.argv[3]
    senderaddr = sys.argv[4]

    if not email or not constr or not senderaddr:
        exit()

    f = open(sys.argv[1] + ".new", "r")
    if not f:
        exit()

    subject = f.readline().strip()
    if not subject:
        exit()

    body = ""
    while True:
        line = f.readline()
        if line:
            body = body + line
        else:
            break
    f.close()

    try:
        connection_string = constr
        client = EmailClient.from_connection_string(connection_string)

        message = {
            "senderAddress": senderaddr,
            "recipients":  {
                "to": [{"address": email }],
            },
            "content": {
                "subject": subject,
                "plainText": body,
            }
        }

        poller = client.begin_send(message)
        result = poller.result()

    except Exception as ex:
        print(ex)
main()
