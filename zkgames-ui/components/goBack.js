import Link from "next/link";

export default function GoBack() {
  return (
    <div>
      <Link href="/">
        <a className="flex w-max ml-5 font-medium space-x-1 text-indigo-300 p-3 transition-colors duration-150 rounded-md bg-slate-800 hover:bg-slate-700">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            width="24"
            height="24"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            strokeWidth="2"
            strokeLinecap="round"
            strokeLinejoin="round"
            className="feather feather-arrow-left w-5"
          >
            <line x1="19" y1="12" x2="5" y2="12"></line>
            <polyline points="12 19 5 12 12 5"></polyline>
          </svg>
          <span>Go back</span>
        </a>
      </Link>
    </div>
  );
}
