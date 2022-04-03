# ALIS - Arch Linux Installation Scripts

Apenas um script que automatiza grande parte da instalação do Arch Linux no meu computador. Experimentado, mas sem garantias, de que vá instalar o Arch Linux AO LADO do Windows em UEFI (sem secure boot). O script instala o Arch Linux com o usuário criado com acesso sudo e com o ambiente gráfico GNOME mais recente.

As configurações abaixo, assim como o próprio script de instalação, foram editados para o meu uso. Sinta-se livre de fazer um fork para sua conta e o editar para as suas necessidades.

**OBS.: Nenhum dos scripts neste repositório estão assegurados de que funcionarão 100%, tenha isso em mente**.

**1.0** - Pré-instalação

**1.1** - Verificação de conexão e relógio
    
Conexão com a internet

    # ping 8.8.8.8 -c 4

Relógio em UTC

    # timedatectl set-ntp true
    # timedatectl status

**1.2** - Particionamento e formatação. O espaço que eu reservei para o meu Arch Linux no meu computador foi de 200 GB, e eu resolvi dividir este espaço nos seguintes termos.

    # cfdisk

    > Criar uma partição de 34 GB para ROOT
    > Criar uma partição de 150 GB HOME
    > Criar uma partição de 16 GB para SWAP

    # mkfs.ext4 /dev/sda4 && mkfs.ext4 /dev/sda5
    # mkswap /dev/sda6 && swapon /dev/sda6
    # mount /dev/sda4 /mnt
    # mkdir /mnt/efi
    # mount /dev/sda1 /mnt/efi
    # mkdir /mnt/home
    # mount /dev/sda5 /mnt/home

**1.3** - Atualização dos repositórios e instalação do GIT e do editor Nano

    # pacman -Sy git nano

**1.4** - Clonagem do repositório

    # cd /tmp
    # git clone https://github.com/henriquepicanco/alis.git
    # cd alis
    # nano alis.sh

O script de instalação será aberto no editor NANO, pois é preciso fazer algumas edições. Por padrão, há alguns *placeholders*, logo no início do arquivo ***alis.sh***, que lhe indicarão qual informação é necessária naquele comando. A lista é a seguinte:

**HOSTN=NOME**

Este *placeholder* indica o nome que seu computador exibirá para outros computadores conectados na mesma rede. Troque **NOME** por um nome único para o seu computador na rede doméstica. Você pode usar letras maiúsculas e minúsculas. Evite espaços e recomendo não usar caracteres especiais, exceto o hífem.

**LOCALE=America/Sao_Paulo**

Este *placeholder* indica o seu fuso horário. Troque-o pelo seu fuso horário. Se você mora nas regiões dentro do horário de brasília e que tem horário de verão, não é preciso mudar esta linha. Do contrário, busque por uma lista de fuso horários disponíveis para a sua região.

**ROOT_PASSWD=SENHA**

Esta é uma senha específica para o usuário ROOT. Troque **SENHA** por uma senha única.

**USER=USUÁRIO**

Este é o seu usuário pessoal, para o uso diário e que terá permissões para usar SUDO. Troque **USUÁRIO** por um nome à sua escolha.

**USER_PASSWD=SENHA**

Esta é uma senha específica para o seu usuário pessoal. Troque **SENHA** por uma senha única, **diferente da senha usada para o ROOT**, por questões de segurança.

**KEYBOARD_LAYOUT=us-acentos**

Esta é a linha que especifica o layout do meu teclado para o sistema instalado. Substitua o "us-acentos" pelo layout do seu teclado.

**2.0** - Tornando executável - e executando

Salve o arquivo e saia. Agora, torne-o executável e execute-o:

    # chmod +x alis.sh
    # ./alis.sh

Deste momento em diante, nenhum outro comando será necessário. O script instalará o sistema e desligará o computador após a sua conclusão.

---


Siga-me no Twitter: [@HenriquePicanco](https://twitter.com/henriquepicanco)
