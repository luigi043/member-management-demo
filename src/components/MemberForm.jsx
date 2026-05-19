import { useState, useEffect } from 'react';
import { validateMember } from '../utils/validation.js';

// ---------------------------------------------------------------------------
// MemberForm
// Controlled form used for BOTH creating and editing a member.
// When `initial` is provided the form runs in "edit" mode and pre-fills fields.
// Validation runs on submit; inline errors are shown per field.
// ---------------------------------------------------------------------------
const EMPTY = { name: '', email: '', role: 'Member' };

export default function MemberForm({ initial = null, onSubmit, onCancel }) {
  const [form, setForm] = useState(EMPTY);
  const [errors, setErrors] = useState({});

  // Re-sync local state when the member being edited changes.
  useEffect(() => {
    setForm(initial ? { ...EMPTY, ...initial } : EMPTY);
    setErrors({});
  }, [initial]);

  function handleChange(e) {
    const { name, value } = e.target;
    setForm((prev) => ({ ...prev, [name]: value }));
  }

  function handleSubmit(e) {
    e.preventDefault();
    const { valid, errors: fieldErrors } = validateMember(form);
    if (!valid) {
      setErrors(fieldErrors);
      return;
    }
    onSubmit(form);
    if (!initial) setForm(EMPTY); // reset only after a create
  }

  return (
    <form className="member-form" onSubmit={handleSubmit} noValidate>
      <h2>{initial ? 'Edit member' : 'Add member'}</h2>

      <label>
        Name
        <input name="name" value={form.name} onChange={handleChange} />
        {errors.name && <span className="field-error">{errors.name}</span>}
      </label>

      <label>
        Email
        <input name="email" value={form.email} onChange={handleChange} />
        {errors.email && <span className="field-error">{errors.email}</span>}
      </label>

      <label>
        Role
        <select name="role" value={form.role} onChange={handleChange}>
          <option>Member</option>
          <option>Admin</option>
          <option>Guest</option>
        </select>
      </label>

      <div className="form-actions">
        <button type="submit">{initial ? 'Save changes' : 'Add member'}</button>
        {initial && (
          <button type="button" className="secondary" onClick={onCancel}>
            Cancel
          </button>
        )}
      </div>
    </form>
  );
}
