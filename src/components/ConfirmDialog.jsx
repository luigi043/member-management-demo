// ---------------------------------------------------------------------------
// ConfirmDialog
// Minimal confirmation modal used before destructive actions (delete).
// Renders nothing when `open` is false.
// ---------------------------------------------------------------------------
export default function ConfirmDialog({ open, message, onConfirm, onCancel }) {
  if (!open) return null;

  return (
    <div className="dialog-backdrop" role="dialog" aria-modal="true">
      <div className="dialog">
        <p>{message}</p>
        <div className="dialog-actions">
          <button className="danger" onClick={onConfirm}>
            Delete
          </button>
          <button className="secondary" onClick={onCancel}>
            Cancel
          </button>
        </div>
      </div>
    </div>
  );
}
