# ARMv7 C/C++ Toolchain for the MiSTer FPGA (DE10-Nano)

This (hopefully) gives you a frictionless development environment with everything you need to compile
code written in **C/C++** targeting the **MiSTer** (DE10-Nano) or any other device with an ARMv7 architecture
using Docker to run Arm containers on x86/64 platforms without the hassle of dealing with cross-compilation
or waste countless hours rewriting or adapting `Makefile`.

> This image compressed comes to **271.48 MB**, but with its base layers the total on disk is **1.1GB**.

## Terasic DE10-Nano <abbr title="Hard Processor System">HPS</abbr> Information

|  | Information |
| ---- | ----------- |
| **CPU** | Dual ARM Cortex-A9 MPCore with CoreSight @ 800MHz |
| **Model** | Intel 5CSEBA6U23I7N |
| **Architecture** | ARMv7-A |
| **ARM Core** | Cortex-A9 MP core |
| **FPU** | VFPv3-D32 (VFP and NEON) |
| **Features** | half thumb fastmult vfp edsp thumbee neon vfpv3 tls vfpd32 |
| **Memory** | 1GB DDR3 SDRAM (32-bit data bus) |
| **GCC Optimization Flags** | `-mcpu=cortex-a9 -mfloat-abi=hard -mtune=cortex-a9 -mfpu=neon` *(alias for `neon-vfpv3`)* |

> The variable CFLAGS `-mcpu=cortex-a9 -mfloat-abi=hard -mtune=cortex-a9 -mfpu=neon` is already set-up in the environment.

## Using the Docker Engine to run Arm containers on PC/Mac with an Intel CPU

As soon as you try to start an Arm-based container on a x86/x64 platform you'll get an error message:

```bash
exec user process caused "exec format error"
```

Which means that the image tried to start a binary/executable which can’t be run on the current platform.

For that we need to run the **magic** command to enable **Arm** and **Arm64** containers to work

```bash
docker run --rm --privileged hypriot/qemu-register
```

![Shia Labeouf Magic](https://media.giphy.com/media/12NUbkX6p4xOO4/giphy.gif)

BOOM! And just like that a few Qemu emulators will be registered and instruct the loader to start the specific emulator to run the binary/executable if you try to run an Arm based container.

## How to use this image

### Linux/Mac Terminal

```bash
docker run -it --rm -v $(pwd):/mister misterkun/toolchain /bin/bash
```

### Windows

Windows Command Line (`cmd`)

```cmd
docker run -it --rm -v %cd%:/mister misterkun/toolchain /bin/bash
```

Windows PowerShell, `${pwd}` also works on Debian/Ubuntu

```powershell
docker run -it --rm -v ${pwd}:/mister misterkun/toolchain /bin/bash
```

Where:
- `docker run` spins up the container from the image
- `-it` specifies that you want an interactive TTY
- `--rm` tells it to remove this temporary image when it exits
- `-v <cmd>` mounts a volume on the current directory and `:/mister` makes a project directory within the container mapped to it
- `misterkun/toolchain` is our Docker Image and
- `/bin/bash` to log into the container.

You will be dropped inside to the container with access to your files where you can `make` or do whatever you feel compelled to do at that point. :)

> Alternatively you can also issue a command without having to log into the container, eg.:
>
> ```bash
> docker run -it --rm -v ${pwd}:/mister misterkun/toolchain make
> ```

#### Shared Drive on Windows

If you encounter this error:

```text
C:\Program Files\Docker\Docker\Resources\bin\docker.exe: Error response from daemon: Drive has not been shared.
See 'C:\Program Files\Docker\Docker\Resources\bin\docker.exe run --help'.
```

Open your Docker's settings and add the drive you're attempting to share/mount inside the container under "Shared Drives".

### Life Hack

Add an `alias` to your profile:

Mac: `nano ~/.bash_profile`
Linux: `nano ~/.profile` or `nano ~/.bashrc`

```bash
alias mtc='f(){ docker run -it --rm -v "$(pwd)":/mister misterkun/toolchain "$@"; unset -f f; }; f'
```

Windows PowerShell: `${Home}\Documents\WindowsPowerShell\Profile.ps1`

```powershell
Function _mtc { docker run -it --rm -v ${pwd}:/mister misterkun/toolchain @Args }
Set-Alias -Name mtc -Value _mtc
```

From now on you can simply type `mtc` to log into the container on the current folder, or just `mtc make` to compile your source code.

## Example

Compiling Main_MiSTer

> **git** is already installed inside the container so if you don't have installed on your computer you don't need to worry about it.

### Inside the Container

In this example we'll create a new folder inside our `projects` folder and clone the repository inside the container.

```bash
developer@misterkun:/home/developer/projects/# mkdir Main_MiSTer && cd Main_MiSTer
developer@misterkun:/home/developer/projects/Main_MiSTer/# mtc
root@c7436718f6bc:/mister$ git clone https://github.com/MiSTer-devel/Main_MiSTer.git .
Cloning into '.'...
remote: Enumerating objects: 66, done.
remote: Counting objects: 100% (66/66), done.
remote: Compressing objects: 100% (45/45), done.
remote: Total 3928 (delta 35), reused 49 (delta 21), pack-reused 3862
Receiving objects: 100% (3928/3928), 13.76 MiB | 5.56 MiB/s, done.
Resolving deltas: 100% (2662/2662), done.
root@c7436718f6bc:/mister$ make
sxmlc.c
lib/miniz/miniz.c
lib/miniz/miniz_tinfl.c
lib/miniz/miniz_zip.c
lib/miniz/miniz_tdef.c
lib/md5/md5.c
lib/libco/arm.c
cheats.cpp
recent.cpp
cfg.cpp
spi.cpp
user_io.cpp
fpga_io.cpp
joymapping.cpp
battery.cpp
hardware.cpp
charrom.cpp
brightness.cpp
video.cpp
bootcore.cpp
osd.cpp
DiskImage.cpp
file_io.cpp
scaler.cpp
input.cpp
menu.cpp
scheduler.cpp
ini_parser.cpp
support/minimig/minimig_hdd.cpp
support/minimig/minimig_config.cpp
support/minimig/minimig_boot.cpp
support/minimig/minimig_fdd.cpp
support/sharpmz/sharpmz.cpp
support/archie/archie.cpp
support/st/st_tos.cpp
support/st/st_ikbd.cpp
support/x86/x86.cpp
support/snes/snes.cpp
support/neogeo/loader.cpp
support/arcade/buffer.cpp
support/arcade/romutils.cpp
support/megacd/megacd.cpp
support/megacd/cdd.cpp
lib/lodepng/lodepng.cpp
make: Circular logo.png <- logo.png.o dependency dropped.
logo.png
main.cpp
MiSTer
root@c7436718f6bc:/mister/$ exit
developer@misterkun:/home/developer/projects/Main_MiSTer/# ls
battery.cpp       charrom.cpp      file_io.cpp.d          ini_parser.cpp.d  main.cpp.d              osd.h            spi.h
battery.cpp.d     charrom.cpp.d    file_io.cpp.o          ini_parser.cpp.o  main.cpp.o              recent.cpp       support
battery.cpp.o     charrom.cpp.o    file_io.h              ini_parser.h      Makefile                recent.cpp.d     support.h
battery.h         charrom.h        fpga_base_addr_ac5.h   input.cpp         menu.cpp                recent.cpp.o     sxmlc.c
bootcore.cpp      cheats.cpp       fpga_io.cpp            input.cpp.d       menu.cpp.d              recent.h         sxmlc.c.d
bootcore.cpp.d    cheats.cpp.d     fpga_io.cpp.d          input.cpp.o       menu.cpp.o              releases         sxmlc.c.o
bootcore.cpp.o    cheats.cpp.o     fpga_io.cpp.o          input.h           menu.h                  scaler.cpp       sxmlc.h
bootcore.h        cheats.h         fpga_io.h              joymapping.cpp    MiSTer                  scaler.cpp.d     user_io.cpp
brightness.cpp    clean.sh         fpga_manager.h         joymapping.cpp.d  MiSTer.elf              scaler.cpp.o     user_io.cpp.d
brightness.cpp.d  coeff_nn.txt     fpga_nic301.h          joymapping.cpp.o  MiSTer.ini              scaler.h         user_io.cpp.o
brightness.cpp.o  coeff_pp.txt     fpga_reset_manager.h   joymapping.h      MiSTer.jpg              scheduler.cpp    user_io.h
brightness.h      debug.h          fpga_system_manager.h  lib               MiSTer.sln              scheduler.cpp.d  video.cpp
build.sh          DiskImage.cpp    hardware.cpp           LICENSE           MiSTer.vcxproj          scheduler.cpp.o  video.cpp.d
cfg.cpp           DiskImage.cpp.d  hardware.cpp.d         logo.h            MiSTer.vcxproj.filters  scheduler.h      video.cpp.o
cfg.cpp.d         DiskImage.cpp.o  hardware.cpp.o         logo.png          osd.cpp                 spi.cpp          video.h
cfg.cpp.o         DiskImage.h      hardware.h             logo.png.o        osd.cpp.d               spi.cpp.d
cfg.h             file_io.cpp      ini_parser.cpp         main.cpp          osd.cpp.o               spi.cpp.o

```

> You can safely ignore the notes/warning thrown by the compiler in this example

### From outside of the container

In this example will clone the repository using the `git` inside the container and `make` without logging into the container

```bash
developer@misterkun:/home/developer/projects/# mtc git clone https://github.com/MiSTer-devel/Main_MiSTer.git
developer@misterkun:/home/developer/projects/# cd Main_MiSTer
developer@misterkun:/home/developer/projects/Main_MiSTer/# mtc make
```

## Further Reading

- [Cyclone V Hard Processor System Technical Reference Manual](https://www.intel.com/content/dam/www/programmable/us/en/pdfs/literature/hb/cyclone-v/cv_54028.pdf)
- [Introducing NEON Development Article](http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.dht0002a/ch01s03s02.html)
- [Cortex-A9 NEON - Technical Reference Manual](https://static.docs.arm.com/ddi0409/i/DDI0409I_cortex_a9_neon_mpe_r4p1_trm.pdf)
- [Demystifying ARM Floating Point Compiler Options](https://embeddedartistry.com/blog/2017/10/11/demystifying-arm-floating-point-compiler-options/)
- [Understanding the Six PowerShell Profiles](https://devblogs.microsoft.com/scripting/understanding-the-six-powershell-profiles/)

## What's in the Box

![What's in the Box](https://media.giphy.com/media/3otPoPkqjANWVH4SUE/giphy.gif)

### From Source/Release

| Package               | Version |
| --------------------- | ------- |
| CMake                 | 3.16.2  |
| Boost C++ Libraries   | 1.72.0  |

### Packages

| Package               | Version |
| --------------------- | --------- |
| autoconf              | 2.69 |
| automake              | 1.15 |
| bash                  | 4.4 |
| bash-completion       | 2.1 |
| binutils              | 2.28 |
| bison                 | 3.0.4 |
| checkinstall          | 1.6.2 |
| cpp                   | 6.3.0 |
| curl                  | 7.52.1 |
| diffutils             | 3.5 |
| file                  | 5.30 |
| flex                  | 2.6.1 |
| g++                   | 6.3.0 |
| gcc                   | 6.3.0 |
| gdb                   | 7.12 |
| git                   | 2.11.0 |
| gpgv                  | 2.1.18 |
| gzip                  | 1.6 |
| iputils-ping          | 3 |
| less                  | 481 |
| libasan3              | 6.3.0 |
| libc                  | 2.24 |
| libfreetype6          | 2.6.3 |
| libgcc                | 6.3.0 |
| libgcc                | 6.3.0 |
| libglib               | 2.50.3 |
| libgmp                | 6.1.2 |
| libjsoncpp            | 1.7.4 |
| liblz4-tool           | 0.0~r131 |
| liblzma5              | 5.2.2 |
| libncurses5           | 6.0 |
| libpng                | 1.6.28 |
| libssl                | 1.1.0l |
| libtcmalloc           | 2.5-2.2 |
| libtool               | 2.4.6 |
| libubsan              | 6.3.0 |
| libusb                | 0.1.12 |
| locales               | 2.24 |
| m4                    | 1.4.18 |
| make                  | 4.1 |
| nano                  | 2.7.4 |
| nasm                  | 2.12.01 |
| p7zip                 | 16.02 |
| patch                 | 2.7.5 |
| python3.5-minimal     | 3.5.3 |
| sshpass               | 1.06 |
| tree                  | 1.7.0 |
| unzip                 | 6.0 |
| wget                  | 1.18 |
| xz-utils              | 5.2.2 |

## Reporting Issues

Please raise any issue on the [repository](https://github.com/misterkun-io/Toolchain_MiSTer/issues)

## License

As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained).

As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.
