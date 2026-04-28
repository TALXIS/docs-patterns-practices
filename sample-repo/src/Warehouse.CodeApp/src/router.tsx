//
//  ╔══════════════════════════════════════════════════════════════════════════════════════╗
//  ║                                                                                      ║
//  ║                       CFK03: Application routing configuration                       ║
//  ║                                                                                      ║
//  ╚══════════════════════════════════════════════════════════════════════════════════════╝
//
// File: src/router.tsx
//
// Defines all client-side routes using react-router-dom createBrowserRouter.
//
// Route map:
//   /              -> WarehouseItemsPage    (index route, list of all warehouse items)
//   /items/:id     -> WarehouseItemDetailPage (single item detail with related transactions)
//   /transactions  -> TransactionsPage       (list of all transactions across items)
//
// Layout: all routes wrapped in <Layout showHeader={true} />.
// Error boundary: <NotFoundPage /> for unmatched routes.
//
// Power Apps hosting:
//   BASENAME is computed from current URL to support deployment inside Power Apps.
//   Redirects /index.html to the clean base path on load.
//

import { createBrowserRouter } from "react-router-dom"
import Layout from "@/pages/_layout"
import WarehouseItemsPage from "@/pages/warehouse-items"
import WarehouseItemDetailPage from "@/pages/warehouse-item-detail"
import TransactionsPage from "@/pages/transactions"
import NotFoundPage from "@/pages/not-found"

// IMPORTANT: Do not remove or modify the code below!
// Normalize basename when hosted in Power Apps
const BASENAME = new URL(".", location.href).pathname
if (location.pathname.endsWith("/index.html")) {
  history.replaceState(null, "", BASENAME + location.search + location.hash);
}

export const router = createBrowserRouter([
  {
    path: "/",
    element: <Layout showHeader={true} />,
    errorElement: <NotFoundPage />,
    children: [
      { index: true, element: <WarehouseItemsPage /> },
      { path: "items/:id", element: <WarehouseItemDetailPage /> },
      { path: "transactions", element: <TransactionsPage /> },
    ],
  },
], {
  basename: BASENAME // IMPORTANT: Set basename for proper routing when hosted in Power Apps
})