#!/bin/bash

echo "Getting status..."
echo ""
echo ""


echo "📊 Project Status"
echo "================"
echo ""

echo "📄 PRDs:"
if [ -d "${CCPM_PRDS_DIR}" ]; then
  total=$(ls ${CCPM_PRDS_DIR}/*.md 2>/dev/null | wc -l)
  echo "  Total: $total"
else
  echo "  No PRDs found"
fi

echo ""
echo "📚 Epics:"
if [ -d "${CCPM_EPICS_DIR}" ]; then
  total=$(ls -d ${CCPM_EPICS_DIR}/*/ 2>/dev/null | wc -l)
  echo "  Total: $total"
else
  echo "  No epics found"
fi

echo ""
echo "📝 Tasks:"
if [ -d "${CCPM_EPICS_DIR}" ]; then
  total=$(find ${CCPM_EPICS_DIR} -name "[0-9]*.md" 2>/dev/null | wc -l)
  open=$(find ${CCPM_EPICS_DIR} -name "[0-9]*.md" -exec grep -l "^status: *open" {} \; 2>/dev/null | wc -l)
  closed=$(find ${CCPM_EPICS_DIR} -name "[0-9]*.md" -exec grep -l "^status: *closed" {} \; 2>/dev/null | wc -l)
  echo "  Open: $open"
  echo "  Closed: $closed"
  echo "  Total: $total"
else
  echo "  No tasks found"
fi

exit 0
