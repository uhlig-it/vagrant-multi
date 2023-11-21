# Multi-Machine Vagrant Deployment

This project deploys a simple journal app. After deployment with `vagrant up`, it will be available on [http://192.168.42.2/](http://192.168.42.2/).

![](arch.svg)

# Development

## Start

`vagrant up --provider vmware_desktop`

The app will be available at [http://192.168.42.2/](http://192.168.42.2/).

## Iterate

`vagrant destroy -f; vagrant up`

# Troubleshooting

On the VM:

* Follow log files with `sudo journalctl -u journal -f`
* Restart the service with `sudo systemctl restart journal`
