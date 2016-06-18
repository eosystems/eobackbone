#!/bin/bash

# ヘルプメッセージ
usage() {
  echo "Usage: $PROGNAME -e arg [start/stop]"
  echo "Rails Project 直下のフォルダから実行が必要です"
  echo
  echo "オプション:"
  echo "  -h, --help"
  echo "  -e <ARG>     <必須> (development/production)"
  echo
  exit 1
}
source /usr/local/rvm/scripts/rvm
SCRIPT_DIR=$(cd $(dirname $(readlink $0 || echo $0));pwd)

PROGNAME=$(basename $0)
HELP_MSG="'$PROGNAME -h'と指定することでヘルプを見ることができます"

# オプション解析
for OPT in "$@"
do
  case "$OPT" in
    # ヘルプメッセージ
    '-h'|'--help' )
    usage
    exit 1
    ;;

    # 環境指定
    '-e' )
    FLG_ENV=1
    # オプションに引数がなかった場合（必須）
    if [[ -z "$2" ]] || [[ "$2" =~ ^-+ ]]; then
      echo "$PROGNAME:「$1」オプションには引数(development または production)が必要です" 1>&2
      exit 1
    fi
    ARG_ENV="$2"
    if [[ "$ARG_ENV" != "development" ]] && [[ "$ARG_ENV" != "production" ]]; then
      echo "$PROGNAME:「$1」オプションにはdevelopment または productionが使用できます" 1>&2
      exit 1
    fi
    shift 2
    ;;

    # Start/Stop
    'start'|'stop' )
    START_STOP_FLG=$1

    if [[ "$1" == "start" ]]; then
      echo "start delayed job worker"
    fi

    if [[ "$1" == 'stop' ]]; then
      echo "Stop Delayed Job Worker"
    fi
    shift 1
    ;;

esac
done

# -e パラメータがない場合
if [ -z $FLG_ENV ]; then
  echo "$PROGNAME:「-e」オプションは必須です。正しいオプションを指定してください" 1>&2
  echo $HELP_MSG 1>&2
  exit 1
fi

# Start/Stopがない場合
if [ -z $START_STOP_FLG ]; then
  echo "$PROGNAME: Start/Stop のどちらかを指定してください" 1>&2
  echo $HELP_MSG 1>&2
  exit 1
fi

cd ${SCRIPT_DIR}/../
# 起動処理
RAILS_ENV=$ARG_ENV bin/delayed_job -p eobackbone_crawler -i 0 --queues=default $START_STOP_FLG
