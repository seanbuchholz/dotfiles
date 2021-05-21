#!/bin/zsh
source zsh/configs/colors.zsh
aw_title "Beginning install..."

BACKUP_DATE_TIME=$(date "+%y%m%d_%H:%M:%S")
[ ! -d ${PWD}/backups ] && mkdir -p backups
mkdir -p backups/${BACKUP_DATE_TIME}

aw_msg "Backing up Zsh files if necessary..."
[ !ls ${HOME}/.zshrc >/dev/null 2>/dev/null ] || mv ${HOME}/.zshrc /backups/${BACKUP_DATE_TIME}/zshrc.bak
[ !ls ${HOME}/.zshenv >/dev/null 2>/dev/null ] || mv ${HOME}/.zshenv /backups/${BACKUP_DATE_TIME}/zshenv.bak

aw_msg "Creating .zshenv in your home directory..."
touch ${PWD}/.zshenv
echo -e "source ${PWD:c}/zsh/configs/environment.zsh" > ${PWD}/.zshenv
ln -s ${PWD}/.zshenv ${HOME}/.zshenv

aw_msg "Creating .zshrc in your home directory..."
ln -s ${PWD}/.zshrc ${HOME}/.zshrc

aw_msg "Sourcing..."
source ${HOME}/.zshenv
source ${HOME}/.zshrc

aw_title "Creating Symlinks..."
aw_msg "Lint settings..."
ln -s ${PWD}/.prettierrc ${HOME}/.prettierrc

unset BACKUP_DATE_TIME
unset CURRENT_BACKUP_DIR
aw_title "Setup complete!"