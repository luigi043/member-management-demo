import MembersPage from './pages/MembersPage.jsx';

// Root component. Kept intentionally thin: it only mounts the main page so the
// app shell stays stable while features evolve inside MembersPage.
export default function App() {
  return <MembersPage />;
}
