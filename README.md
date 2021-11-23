# PXE Server Docker
Um servidor PXE em um container.

- [Português](README.md)

# Conteúdo
- [PXE Server Docker](#pxe-server-docker)
- [Conteúdo](#conteúdo)
- [Dependências](#dependências)
- [Instruções](#instruções)
  - [Preparar a imagem disponibilizadas pelo servidor](#preparar-a-imagem-disponibilizadas-pelo-servidor)
  - [Atualizar o IP do servidor](#atualizar-o-ip-do-servidor)
  - [Criar a imagem](#criar-a-imagem)
  - [Desmontar a imagem da pasta boot](#desmontar-a-imagem-da-pasta-boot)
  - [Iniciar o servidor](#iniciar-o-servidor)
- [Problemas comuns](#problemas-comuns)
- [TODO](#todo)
- [Referências e projetos similares](#referências-e-projetos-similares)

# Dependências
- [docker](https://docs.docker.com/engine/install/)

# Instruções
Essas instruções server de exemplo para a instalação do Debian 11 - Bullseye. Caso deseje instalar outras distribuições, basta adaptar as instruções a seguir e o arquivo [default](etc/tftpboot/pxelinux.cfg/default).

**Nota:** Algumas dessas instruções podem requerer o permissão de super usuário.

## Preparar a imagem disponibilizadas pelo servidor
Baixe a imagem disponível no [site do Debian](https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/). Assumindo que o arquivo ISO tenha sido baixado em `~/Downloads`, monte o conteúdo da imagem na pasta desejada (para esse cenário, `tftpboot/boot/debian11`).

```bash
$ mkdir -p tftpboot/boot/debian11
$ mount -o loop -t iso9660 ~/Downloads/<imagem> tftpboot/boot/debian11
```

## Atualizar o IP do servidor
Atualize o IP da variável `dhcp-range` (192.168.0.24) no arquivo `etc/dnsmasq.conf` com o IP da máquina em que o servidor será executado. Para saber o IP da máquina, execute.

```bash
$ hostname -I | awk '{print $1}'
```

## Criar a imagem
Crie a imagem docker que será utilizada para o servidor.

```bash
$ docker build -t pxe-server-docker .
```

## Desmontar a imagem da pasta boot
Após gerar a imagem docker, a imagem com o conteúdo da ISO pode ser desmontada do disco local.
```bash
$ umount tftpboot/boot/debian11
```

## Iniciar o servidor
Para iniciar o container criado.

```bash
$ docker run --privileged --rm -it --net=host pxe-server-docker
```

Ao entrar no container, inicie o `dnsmasq`.

```bash
$ dnsmasq --no-daemon
```

# Problemas comuns
- O servidor não recebe a requisição para enviar a imagem.
Alguns sistemas operacionais como o Fedora vem com o firewall habilitado por padrão e apenas o SSH habilitado. Uma possível solução é desabilitar o firewall temporariamente para que o servidor possa ser acessado.
```bash
$ systemctl disable firewalld
$ systemctl stop firewalld
```

# TODO
- Alterar a imagem base para algo menor, como o Alpine.
- Alterar o IP do servidor automaticamente ao iniciar.
- Adicionar instruções para executar o docker como um servidor standalone.
  - `dhcp-server=X.X.X.X, Y.Y.Y.Y, Z.Z.Z.Z`
- Adicionar instruções para utilizar outras imagens.
- Adicionar instruções em outros idiomas.

# Referências e projetos similares
Alguns outros projetos similares
- [docker-pxe @ferrarimarco](https://github.com/ferrarimarco/docker-pxe)
- [pxe @jpetazzo](https://github.com/jpetazzo/pxe)
- [linuxserver/netbootxyz](https://docs.linuxserver.io/images/docker-netbootxyz)
- [PXE Booting from a Container](https://warlord0blog.wordpress.com/2020/02/29/pxe-booting-from-a-container/)
- [How to configure a Raspberry Pi as a PXE boot server](https://linuxconfig.org/how-to-configure-a-raspberry-pi-as-a-pxe-boot-server)
