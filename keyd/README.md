# keyd - Key Remapping Configuration

System-wide key remapping using [keyd](https://github.com/rvaiya/keyd).

## Features

- **Capslock as Escape/Control**: Tap for escape, hold for control
- **AZERTY number row swap**: Numbers by default, symbols with Shift
- **Per-device configuration**: Only applies to laptop keyboard, external QWERTY keyboards unaffected

## Quick Start

### 1. Install keyd

**Ubuntu 25.04+ / 26.04 LTS:**

```bash
sudo apt install keyd
```

### 2. Run install script

```bash
cd ~/git/dotfiles/keyd
chmod +x install.sh
./install.sh
```

### 3. Verify it works

```bash
# Try typing numbers without shift - should work!
```

### Reload after config changes

```bash
# Ubuntu package uses keyd.rvaiya binary
sudo /usr/bin/keyd.rvaiya reload

# Or restart the service
sudo systemctl restart keyd
```

## Panic Sequence

If your keyboard becomes unusable:

**Press: `backspace` + `escape` + `enter` (simultaneously)**

This will terminate keyd and restore normal keyboard function.

## Configuration Details

### Keyboard IDs

The config only applies to keyboards listed in the `[ids]` section:

| ID | Device | Layout |
|----|--------|--------|
| `0001:0001` | AT Translated Set 2 keyboard (laptop) | AZERTY with number swap |

All other keyboards (like the Logitech MX Keys Mini) use system defaults.

### Finding keyboard IDs on a new machine

```bash
# List all keyd-compatible devices
sudo /usr/bin/keyd.rvaiya list

# Or monitor key events (shows device info)
sudo /usr/bin/keyd.rvaiya monitor
```

### Current mappings

#### Number row (laptop only)

| Key | Normal | Shift |
|-----|--------|-------|
| 1 key | 1 | & |
| 2 key | 2 | é |
| 3 key | 3 | " |
| 4 key | 4 | ' |
| 5 key | 5 | ( |
| 6 key | 6 | - |
| 7 key | 7 | è |
| 8 key | 8 | _ |
| 9 key | 9 | ç |
| 0 key | 0 | à |

#### Capslock

| Action | Result |
|--------|--------|
| Tap | Escape |
| Hold | Control |

### AltGr characters

AltGr combinations are **unchanged**:

- `AltGr + 6` = `|`
- `AltGr + 0` = `@`
- `AltGr + 3` = `#`
- etc.

## Troubleshooting

### Check service status

```bash
sudo systemctl status keyd
```

### View logs

```bash
sudo journalctl -eu keyd
```

### Validate config

```bash
sudo /usr/bin/keyd.rvaiya check /etc/keyd/default.conf
```

### Test without installing

```bash
# Stop keyd first
sudo systemctl stop keyd

# Monitor raw key events
sudo /usr/bin/keyd.rvaiya monitor

# Restart when done
sudo systemctl start keyd
```

## Hyprland Configuration

When switching to Hyprland, you can also configure per-device keyboards in `~/.config/hypr/hyprland.conf`:

```
# Laptop AZERTY keyboard
device {
    name = at-translated-set-2-keyboard
    kb_layout = fr
    kb_variant = 
    kb_options = 
}

# External QWERTY keyboard (e.g., MX Keys Mini)
device {
    name = mx-keys-mini-keyboard
    kb_layout = us
    kb_variant = 
    kb_options = 
}
```

**Note:** Get exact device names with `hyprctl devices` when Hyprland is running.

You can use **both** keyd and Hyprland's per-device config:

- keyd handles: capslock behavior, number row swap
- Hyprland handles: base layout (fr/us)

## Future: Ansible Automation

For automating the full dotfiles installation across machines, consider using Ansible.

### Example structure

```
dotfiles/
├── ansible/
│   ├── inventory.yml
│   ├── playbook.yml
│   └── roles/
│       ├── keyd/
│       │   └── tasks/main.yml
│       ├── tmux/
│       │   └── tasks/main.yml
│       └── ...
```

### Example keyd role (`ansible/roles/keyd/tasks/main.yml`)

```yaml
---
- name: Install keyd
  become: yes
  apt:
    name: keyd
    state: present

- name: Create keyd config directory
  become: yes
  file:
    path: /etc/keyd
    state: directory
    mode: '0755'

- name: Symlink keyd config
  become: yes
  file:
    src: "{{ dotfiles_path }}/keyd/keyd.conf"
    dest: /etc/keyd/default.conf
    state: link

- name: Enable and start keyd service
  become: yes
  systemd:
    name: keyd
    enabled: yes
    state: started

- name: Reload keyd config
  become: yes
  command: /usr/bin/keyd.rvaiya reload
  changed_when: false
```

### Example playbook (`ansible/playbook.yml`)

```yaml
---
- hosts: localhost
  vars:
    dotfiles_path: "{{ ansible_env.HOME }}/git/dotfiles"
  
  roles:
    - keyd
    - tmux
    # Add more roles as needed
```

### Running ansible

```bash
# Install ansible
sudo apt install ansible

# Run playbook
cd ~/git/dotfiles/ansible
ansible-playbook -K playbook.yml
```

This allows you to:

- Run a single command to set up a new machine
- Keep all installation logic version-controlled
- Easily add new tools/configs as roles

## References

- [keyd GitHub](https://github.com/rvaiya/keyd)
- [keyd man page](https://github.com/rvaiya/keyd/blob/master/docs/keyd.scdoc)
- [Hyprland wiki - Keywords](https://wiki.hyprland.org/Configuring/Keywords/#per-device-input-configs)
