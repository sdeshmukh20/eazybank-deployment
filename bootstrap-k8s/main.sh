#!/bin/bash

chmod +x script-exe.sh
source script-exe.sh
# Load YAML config
CONFIG_FILE="action-config.yaml"
if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "Error: Config file '$CONFIG_FILE' not found."
  exit 1
fi

# Initialize variables for arguments
ENV_VALUE=""
SVC_VALUE=""
VERSION_VALUE=""
ACTION=""

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    -env)
      ENV_VALUE="$2"
      shift 2
      ;;
    -action)
      ACTION="$2"
      shift 2
      ;;
    -svc)
      SVC_VALUE="$2"
      shift 2
      ;;
    -version)
      VERSION_VALUE="$2"
      shift 2
      ;;
    *)
      echo "Unknown argument: $1"
      exit 1
      ;;
  esac
done

# Validate action
if [[ -z "$ACTION" ]]; then
  echo "Error: -action is required."
  exit 1
fi

# Function to get YAML value
get_yaml_value() {
  local path="$1"
  yq eval ".actions.${ACTION}.${path}" "$CONFIG_FILE"
}

# Check if action exists
ACTION_EXISTS=$(yq eval ".actions.${ACTION}" "$CONFIG_FILE")
if [[ "$ACTION_EXISTS" == "null" ]]; then
  echo "Error: Unknown action '$ACTION'."
  exit 1
fi

# Check required arguments
REQUIRED_ARGS=$(get_yaml_value "required_args" | yq eval '.[]' -)
for arg in $REQUIRED_ARGS; do
  case "$arg" in
    "env")
      if [[ -z "$ENV_VALUE" ]]; then
        echo "Error: Missing required argument 'env' for action '$ACTION'."
        exit 1
      fi
      ;;
    "svc")
      if [[ -z "$SVC_VALUE" ]]; then
        echo "Error: Missing required argument 'svc' for action '$ACTION'."
        exit 1
      fi
      ;;
    "version")
      if [[ -z "$VERSION_VALUE" ]]; then
        echo "Error: Missing required argument 'version' for action '$ACTION'."
        exit 1
      fi
      ;;
  esac
done

# Get script path (now always a direct string)
SCRIPT=$(get_yaml_value "script")
if [[ "$SCRIPT" == "null" ]]; then
  echo "Error: No script defined for action '$ACTION'."
  exit 1
fi

# Build command arguments
CMD_ARGS=()
ARGS_MAPPING=$(get_yaml_value "args_mapping" | yq eval '.[]' -)
if [[ -n "$ARGS_MAPPING" ]]; then
  while IFS= read -r arg; do
    case "$arg" in
      '$env')
        CMD_ARGS+=("$ENV_VALUE")
        ;;
      '$svc')
        CMD_ARGS+=("$SVC_VALUE")
        ;;
      '$version')
        CMD_ARGS+=("$VERSION_VALUE")
        ;;
      *)
        CMD_ARGS+=("$arg")
        ;;
    esac
  done <<< "$ARGS_MAPPING"
fi

cd commands || exit 1

# Debug output
echo "[DEBUG] Script: $SCRIPT"
if [[ ${#CMD_ARGS[@]} -gt 0 ]]; then
    printf "[DEBUG] Arguments:"
    printf " '%s'" "${CMD_ARGS[@]}"
    printf "\n"
else
    echo "[DEBUG] No arguments"
fi
echo "[DEBUG] Number of arguments: ${#CMD_ARGS[@]}"

# Execute the command
if [[ -x "$SCRIPT" ]]; then
  echo "[INFO] Executing: $SCRIPT" "${CMD_ARGS[@]}"
  "$SCRIPT" "${CMD_ARGS[@]}"
  EXIT_CODE=$?
else
  echo "Error: Script '$SCRIPT' not found or not executable"
  EXIT_CODE=1
fi

cd ../
exit $EXIT_CODE