# Vault

## Start Vault

First, generate x509 CA cert, see [TLS readme](TLS.md).

Then ``docker-compose up -d``

## Setup Env

> ``VAULT_TOKEN`` will be available right after ``vault init``
> or whenever you want to generate root token using unseal keys.
> https://www.vaultproject.io/guides/generate-root.html

```
export VAULT_ADDR=https://localhost:8200
export VAULT_TOKEN=8befefbe-abbc-d1a7-2f0f-5c40439ac807
```

## Init

```
$ vault init
Unseal Key 1: 18xysjfz/GtSHWvElsW3owWFq5QtPmLJut/hL/T7OSNa
Unseal Key 2: aisg6S97HPP/cNEElz0uWgSaYuD3ZFLKM5xymqhh0+ch
Unseal Key 3: aWAyhwCW5rcEvvZWCnEDTsgnhvYSGwFno00JidwOfS1W
Unseal Key 4: IQXKb4/3G6Gl/cGXwc4PPp2O/oUl9lPNpl8zWTOqTNWz
Unseal Key 5: aQ+aOIf0AdjCgiuok6DWj5rHOyMlrOerTGsXb8nef74v
Initial Root Token: 8befefbe-abbc-d1a7-2f0f-5c40439ac807

vault      | 2017/09/25 08:19:00.222004 [INFO ] core: successfully setup plugin catalog: plugin-directory=
vault      | 2017/09/25 08:19:00.222929 [INFO ] core: successfully mounted backend: type=kv path=secret/
vault      | 2017/09/25 08:19:00.222953 [INFO ] core: successfully mounted backend: type=cubbyhole path=cubbyhole/
vault      | 2017/09/25 08:19:00.223045 [INFO ] core: successfully mounted backend: type=system path=sys/
```

## Unseal

This has to be done each time Vault restarts or when is manually sealed.

```
vault status
vault unseal 18xysjfz/GtSHWvElsW3owWFq5QtPmLJut/hL/T7OSNa
vault unseal aisg6S97HPP/cNEElz0uWgSaYuD3ZFLKM5xymqhh0+ch
vault unseal aWAyhwCW5rcEvvZWCnEDTsgnhvYSGwFno00JidwOfS1W
vault status
```

## Examples

```
vault write /secret/test my1=val1
vault read /secret/test
val1
```

Read a secret using API:

```
$ curl --cacert ca.pem -sSL -X GET -H "X-Vault-Token:$VAULT_TOKEN" https://localhost:8200/v1/secret/test | jq -r .data.my1
```

```
vault read /sys/mounts
vault read /sys/policy
vault read /sys/policy/default
vault read /sys/policy/root
```

## Production

- use IPC_LOCK capability when running Vault server
- remove Root Token
- use end-to-end TLS
- enable auditing

And more https://www.vaultproject.io/guides/production.html

## Links

- https://www.vaultproject.io/api/system/health.html
