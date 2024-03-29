# PostGIS

Container running [PostgreSQL with the spatial extension PostGIS](https://registry.hub.docker.com/r/postgis/postgis/).

## Usage with docker

* Start postgis :

```bash
export POSTGRES_USER=postgis
export POSTGRES_PASSWORD=ChangeIt
docker compose up -d
```

* Configure psql (`~/.profile`) :

```bash
export PGHOST=localhost
export PGUSER=postgis
export PGPASSWORD=ChangeIt
```

* Create gis database

```bash
createdb gis
psql -d gis -c "CREATE EXTENSION postgis"
```

## Usage with Kubernetes

Read [k8s-install.sh](k8s-install.sh) and run :

```bash
bash k8s-install.sh
```

Note that :

* Password is generated by bitnami's helm chart and stored in a secret named "gis-postgresql" :

```bash
export POSTGRES_PASSWORD=$(kubectl get secret --namespace postgis gis-postgresql -o jsonpath="{.data.postgres-password}" | base64 -d)
```

* Internal hostname is `gis-postgresql.postgis.svc.cluster.local`
* You can also use port-forwarding : `kubectl port-forward --namespace postgis svc/gis-postgresql 15432:5432`


## See also

For Kubernetes :

* [PostgreSQL packaged by Bitnami](https://github.com/bitnami/charts/tree/main/bitnami/postgresql/#postgresql-packaged-by-bitnami)

* PostgreSQL operators like :
    * [zalando/postgres-operator](https://github.com/zalando/postgres-operator)
    * [CrunchyData/postgres-operator](https://github.com/CrunchyData/postgres-operator)
    * ...

To tune PostgreSQL :

* [pgtune.leopard.in.ua](http://pgtune.leopard.in.ua/)
* [urator.cybertec.at](http://pgconfigurator.cybertec.at/)
* [github.com - esgn/pgtuned](https://github.com/esgn/pgtuned#pgtuned--)
