## OpenShift

To deploy this example into OpenShift:

```
oc apply -k .
```

Because this example includes a `RoleBinding` that grants elevated privileges, you will need to apply this to a cluster for which you have cluster admin privileges. Once the build is finished, you may need to delete and re-create the Deployment:

```
oc delete deployment uidexample
oc apply -k .
```

## Local Image

To build an image locally (assuming a typical Podman installation), run:

```
make image
```

This will build the image with `POSITRON_UID` set to `50001` and `JOB_RUNNER_UID` set to `50002`, which unlike the default uid/gid will work the default configuration of `/etc/subuid`, which typically only grants 65535 uids to each user.
