#
# ╔════════════════════════════════════════════════════════════════════════════════════════╗
# ║         12: Generative Page — Warehouse Dashboard (React 17 + Fluent UI V9)            ║
# ╚════════════════════════════════════════════════════════════════════════════════════════╝
#
# Creates a generative page project with a warehouse inventory dashboard.
# The page uses props.dataApi to query Dataverse tables and renders summary
# cards (total items, locations, low stock alerts) plus an inventory table.
#
# Expects: $PublisherPrefix from parent scope.
#
# ──────────────────────────────────────────────────────────────────────────────────────────

Write-Host "`n── Generative Page: Warehouse Dashboard ──" -ForegroundColor Cyan

# ──────────────────────────────────────────────────────────────────────────────────────────
#                            Scaffold GenPage Project
# ──────────────────────────────────────────────────────────────────────────────────────────

dotnet new pp-page-generative `
    --output "src/GenPages.Dashboard" `
    --Name "warehousedashboard" `
    --DisplayName "Warehouse Dashboard"

Write-Host "  ✓ GenPages.Dashboard project created" -ForegroundColor Green

# Read the generated GenPageId from the .csproj
$csprojPath = "src/GenPages.Dashboard/GenPages.Dashboard.csproj"
$csprojXml = [xml](Get-Content $csprojPath -Raw)
$genPageId = $csprojXml.Project.PropertyGroup.GenPageId | Where-Object { $_ }
Write-Host "  ℹ GenPageId: $genPageId" -ForegroundColor DarkGray

# ──────────────────────────────────────────────────────────────────────────────────────────
#                           Customize page.tsx — Dashboard
# ──────────────────────────────────────────────────────────────────────────────────────────

$pageTsx = @"
import { useEffect, useState, useCallback } from 'react';
import {
  makeStyles,
  Title1,
  Card,
  CardHeader,
  Text,
  Spinner,
  Badge,
  tokens,
  Table,
  TableHeader,
  TableRow,
  TableHeaderCell,
  TableBody,
  TableCell,
  TableCellLayout,
} from '@fluentui/react-components';
import {
  BoxRegular,
  LocationRegular,
  WarningRegular,
} from '@fluentui/react-icons';
import type { GeneratedComponentProps } from './RuntimeTypes';

const LOW_STOCK_THRESHOLD = 10;

interface WarehouseItem {
  ${PublisherPrefix}_warehouseitemid: string;
  ${PublisherPrefix}_name: string;
  ${PublisherPrefix}_sku: string;
  ${PublisherPrefix}_quantityonhand: number;
  ${PublisherPrefix}_reorderpoint: number;
}

interface DashboardSummary {
  totalItems: number;
  totalLocations: number;
  lowStockCount: number;
}

const useStyles = makeStyles({
  container: {
    display: 'flex',
    flexDirection: 'column',
    gap: tokens.spacingVerticalL,
    padding: tokens.spacingHorizontalXL,
  },
  cardRow: {
    display: 'flex',
    gap: tokens.spacingHorizontalL,
    flexWrap: 'wrap',
  },
  summaryCard: {
    minWidth: '200px',
    flex: '1 1 200px',
  },
  cardBody: {
    display: 'flex',
    alignItems: 'center',
    gap: tokens.spacingHorizontalM,
    padding: tokens.spacingVerticalM,
  },
  cardValue: {
    fontSize: tokens.fontSizeHero800,
    fontWeight: tokens.fontWeightBold,
    lineHeight: tokens.lineHeightHero800,
  },
  lowStock: {
    color: tokens.colorPaletteRedForeground1,
  },
});

const GeneratedComponent = (props: GeneratedComponentProps) => {
  const styles = useStyles();
  const [loading, setLoading] = useState(true);
  const [items, setItems] = useState<WarehouseItem[]>([]);
  const [summary, setSummary] = useState<DashboardSummary>({
    totalItems: 0,
    totalLocations: 0,
    lowStockCount: 0,
  });

  const loadData = useCallback(async () => {
    try {
      const [itemsResult, locationsResult] = await Promise.all([
        props.dataApi.queryTable<WarehouseItem>('${PublisherPrefix}_warehouseitem', {
          select: [
            '${PublisherPrefix}_warehouseitemid',
            '${PublisherPrefix}_name',
            '${PublisherPrefix}_sku',
            '${PublisherPrefix}_quantityonhand',
            '${PublisherPrefix}_reorderpoint',
          ],
          orderBy: '${PublisherPrefix}_quantityonhand asc',
          pageSize: 50,
        }),
        props.dataApi.queryTable('${PublisherPrefix}_warehouselocation', {
          select: ['${PublisherPrefix}_warehouselocationid'],
          pageSize: 1,
        }),
      ]);

      const allItems = itemsResult.rows;
      const lowStock = allItems.filter(
        (i) => i.${PublisherPrefix}_quantityonhand <= (i.${PublisherPrefix}_reorderpoint ?? LOW_STOCK_THRESHOLD)
      );

      setItems(allItems);
      setSummary({
        totalItems: allItems.length,
        totalLocations: locationsResult.rows.length,
        lowStockCount: lowStock.length,
      });
    } finally {
      setLoading(false);
    }
  }, [props.dataApi]);

  useEffect(() => {
    loadData();
  }, [loadData]);

  if (loading) {
    return <Spinner label="Loading dashboard..." />;
  }

  return (
    <div className={styles.container}>
      <Title1>Warehouse Dashboard</Title1>

      {/* Summary cards */}
      <div className={styles.cardRow}>
        <Card className={styles.summaryCard}>
          <CardHeader header={<Text weight="semibold">Total Items</Text>} />
          <div className={styles.cardBody}>
            <BoxRegular fontSize={28} />
            <Text className={styles.cardValue}>{summary.totalItems}</Text>
          </div>
        </Card>

        <Card className={styles.summaryCard}>
          <CardHeader header={<Text weight="semibold">Locations</Text>} />
          <div className={styles.cardBody}>
            <LocationRegular fontSize={28} />
            <Text className={styles.cardValue}>{summary.totalLocations}</Text>
          </div>
        </Card>

        <Card className={styles.summaryCard}>
          <CardHeader header={<Text weight="semibold">Low Stock Alerts</Text>} />
          <div className={styles.cardBody}>
            <WarningRegular fontSize={28} />
            <Text className={``${styles.cardValue} `${summary.lowStockCount > 0 ? styles.lowStock : ''}``}>
              {summary.lowStockCount}
            </Text>
          </div>
        </Card>
      </div>

      {/* Inventory table */}
      <Card>
        <CardHeader header={<Text weight="semibold">Inventory Overview</Text>} />
        <Table>
          <TableHeader>
            <TableRow>
              <TableHeaderCell>Item Name</TableHeaderCell>
              <TableHeaderCell>SKU</TableHeaderCell>
              <TableHeaderCell>Qty on Hand</TableHeaderCell>
              <TableHeaderCell>Reorder Point</TableHeaderCell>
              <TableHeaderCell>Status</TableHeaderCell>
            </TableRow>
          </TableHeader>
          <TableBody>
            {items.map((item) => {
              const isLow = item.${PublisherPrefix}_quantityonhand <= (item.${PublisherPrefix}_reorderpoint ?? LOW_STOCK_THRESHOLD);
              return (
                <TableRow key={item.${PublisherPrefix}_warehouseitemid}>
                  <TableCell>
                    <TableCellLayout>{item.${PublisherPrefix}_name}</TableCellLayout>
                  </TableCell>
                  <TableCell>
                    <TableCellLayout>{item.${PublisherPrefix}_sku}</TableCellLayout>
                  </TableCell>
                  <TableCell>
                    <TableCellLayout>{item.${PublisherPrefix}_quantityonhand}</TableCellLayout>
                  </TableCell>
                  <TableCell>
                    <TableCellLayout>{item.${PublisherPrefix}_reorderpoint}</TableCellLayout>
                  </TableCell>
                  <TableCell>
                    <TableCellLayout>
                      <Badge
                        appearance="filled"
                        color={isLow ? 'danger' : 'success'}
                      >
                        {isLow ? 'Low Stock' : 'In Stock'}
                      </Badge>
                    </TableCellLayout>
                  </TableCell>
                </TableRow>
              );
            })}
          </TableBody>
        </Table>
      </Card>
    </div>
  );
};

export default GeneratedComponent;
"@

Set-Content -Path "src/GenPages.Dashboard/page.tsx" -Value $pageTsx -Encoding UTF8
Write-Host "  ✓ page.tsx customized as warehouse dashboard" -ForegroundColor Green

# ──────────────────────────────────────────────────────────────────────────────────────────
#                       Add ProjectReference from Solutions.UI
# ──────────────────────────────────────────────────────────────────────────────────────────

cd src/Solutions.UI
dotnet add "./Solutions.UI.csproj" reference "../GenPages.Dashboard/GenPages.Dashboard.csproj"
cd ../..

Write-Host "  ✓ ProjectReference: GenPages.Dashboard → Solutions.UI" -ForegroundColor Green

# ──────────────────────────────────────────────────────────────────────────────────────────
#                       Sitemap Subarea (PageType=genpage)
# ──────────────────────────────────────────────────────────────────────────────────────────

dotnet new pp-sitemap-subarea `
    --output "src/Solutions.UI" `
    --PageType "genpage" `
    --Title "Dashboard" `
    --EntityLogicalName "${PublisherPrefix}_warehouseitem" `
    --GenPageId $genPageId `
    --GroupTitle "Management" `
    --AreaTitle "Warehouse" `
    --AppName "${PublisherPrefix}_warehouseapp" `
    --allow-scripts yes

Write-Host "  ✓ Sitemap subarea: Dashboard (genpage)" -ForegroundColor Green
