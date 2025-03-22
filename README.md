# BashGetChildItem

## Summary

BashGetChildItem is tool that imitates Powershell's `Get-ChildItem` cmdlet. It is written in Bash and AWK.
Please mind this is a fun project, that probably wont work on your machine. But any contribution to make
it more robust and cross platform is welcome.

## Installation

Run:

```bash
git clone https://github.com/ajwalkiewicz/BashGetChildItem.git
cd BashGetChildItem
make install
```

## Usage

Run
```
gcs
```

You can also alias it to `ls` command:

```bash
alias ls='gcs`
```

## Limitations

BashGetChildItem was designed to work on my machine. I took a lot of shortcuts to make it working. 
Because of that there is very high chance that it won't work the same on your machine.

## License

(MIT)[LICENSE]

