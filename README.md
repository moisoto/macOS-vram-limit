# Checking and Setting VRAM

The amount of VRAM that macOS uses is limited by the `iogpu.wired_limit_mb` system parameter.

You can change this value to allow more VRAM to be used (or limit it more).

By default this limit is set to 0, which means the system will use the default limit.

You can query this value using the command `sudo sysctl iogpu.wired_limit_mb`, however this is not very usefull when it is set to 0.

The Swift program included in this repository will show you the actual value.

To execute this program:

```shell
./compile.sh
./show_vram_limit
```

## Changing the value.

In order to set a bigger (or lower) value you can use the `sysctl` command.

For example to set it to 14GB:

```shell
# Set wired limit to 14*1024 MBs
sudo sysctl iogpu.wired_limit_mb=14336
```

# Credits/Thanks

Thanks to [Alex Ziskind](https://x.com/digitalix) for his [video](https://youtu.be/nxCtScEImew) on increasing the _iogpu.wired_limit_mb_ value.
